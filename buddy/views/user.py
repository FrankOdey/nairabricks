#!/usr/bin/env python
# -*- coding: utf-8 -*-
from datetime import timedelta, datetime

from pyramid.view import view_config,forbidden_view_config
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound
from pyramid.renderers import render_to_response
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.models.properties_model import Listings
from buddy.models.user_model import Users, User_types, UserWebsites, Groups, AuthUserLog, UserRating, Subscription, \
    Plans
from buddy.models import DBSession
import transaction

from pyramid.security import (
    forget,
    )
from cStringIO import StringIO
import random,os
import base64
import hmac
import time

from buddy.utils.url_normalizer import url_normalizer
from buddy.views.listing.add import make_thumbnail, optimize
from buddy.views.schema import (
    ChangePasswordForm,
    ForgotPasswordForm,
    ResetPasswordForm,
    Registration,
    LoginForm,
    ChangeEmailPassword,
    NoteSchema,
    PersonalSchema,
    AddGroup,
    UserRatingSchema,
    ContactSchema)
from buddy.views.messages import email_forgot, html_email_sender, confirm_email,user_regmail, non_html_email_sender
from buddy.models.resources import Content
from buddy.models.q_model import Answers, Questions
from buddy.views.messages import buddy_remember, buddy_settings
from buddy.views.listing.add import get_states
from webhelpers.paginate import PageURL_WebOb, Page
from sqlalchemy import or_
import requests

recaptcha_endpoint ="https://www.google.com/recaptcha/api/siteverify"
alphabet = 'abcdefghijklmnopqrstuvwxyz'

def make_random_string(length):
    'Return a random string of a specified length'
    return ''.join(random.choice(alphabet) for x in xrange(length))

def make_random_unique_string(length,name, is_unique):
    randomID = name.replace(' ','')[:10] + make_random_string(length)

    # If our randomID is unique, return it
    if is_unique(randomID):
        return randomID

def create_path(name,is_unique):
    path = url_normalizer(name).replace('-','')
    if is_unique(path):
        return path
    else:
        path += str(random.randint(1,8**2))
        if is_unique(path):
            return path
        else:
            create_path(name,is_unique)


def is_unique(path):
    url = Users.get_by_path(path)
    if url:
        return False
    return True

def userTypes():
    return [(s.id,s.name) for s in DBSession.query(User_types).all()]

class UserView(object):

    def __init__(self, request):
        self.request = request
        self.session=request.session

    @view_config(route_name="reg", renderer='buddy:templates/user/reg.mako')
    def reg(self):
        title = 'Registration'
        usertypes = userTypes()
        states = get_states()
        msg=''
        form = Form(self.request, schema=Registration)
        if 'form_submitted' in self.request.POST and form.validate():
            try:
                resp =self.request.POST['g-recaptcha-response']
            except:
                self.request.session.flash('danger; Failed captcha due to slow network')
                return HTTPFound(location=self.request.route_url('reg'))
            recaptcha_r = requests.post(recaptcha_endpoint,dict(secret= buddy_settings('recaptcha_secret'),
                                                                response = resp))
            rdata = recaptcha_r.json()
            if rdata:
                if not rdata['success']:
                    msg='Failed recaptcha, please solve again'
                    return dict(form=FormRenderer(form),msg=msg, title=title, usertypes=usertypes, states=states)

            user = form.bind(Users())
            if 'ref_email' in self.request.session:
                referrer = Users.get_by_email(self.request.session['ref_email'])
                if referrer:
                    user.parent_id = referrer.id
            with transaction.manager:
                DBSession.add(user)
                user.prefix = create_path(user.user_fullname,is_unique)
                DBSession.flush()
                timestamp = time.time()+3600
                hmac_key = hmac.new('%s:%s:%d' % (str(user.id),
                                'r5$55g35%4#$:l3#24&', timestamp),
                                user.email).hexdigest()[0:10]
                time_key = base64.urlsafe_b64encode('%d' % timestamp)
                email_hash = '%s%s' % (hmac_key, time_key)
                user_regmail(self.request, user.id, user.email, email_hash)
                headers = buddy_remember(self.request, user,event='R')
                self.session.flash("success;You should be receiving an email with a link to activate your "
                "account within 10 minutes. Doing so will let you post properties/blog on this website.")
                return HTTPFound(location=self.request.route_url('account'),headers=headers)

        return dict(form=FormRenderer(form),title=title, usertypes = usertypes,msg=msg, states=states)

    @view_config(route_name="delete_user",permission="superadmin")
    def delete(self):
        prefix = self.request.matchdict['prefix']
        user = Users.get_by_path(prefix)
        if user:
            DBSession.delete(user)
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('home'))
        else:
            self.request.session.flash("warning; User not found")
            return HTTPFound(location = '/')

    @view_config(route_name="send_confirmation_email",permission='post')
    def send_email_confirm(self):
        timestamp = time.time()+3600
        hmac_key = hmac.new('%s:%s:%d' % (str(self.request.user.id),
                                'r5$55g35%4#$:l3#24&', timestamp),
                                self.request.user.email).hexdigest()[0:10]
        time_key = base64.urlsafe_b64encode('%d' % timestamp)
        email_hash = '%s%s' % (hmac_key, time_key)
        confirm_email(self.request, self.request.user.id, self.request.user.email, email_hash)
        self.request.session.flash("success; An email confirmation link has been sent to your mailbox, please confirm your email and continue")
        return HTTPFound(location='/')

    @view_config(route_name = "confirm_mail_holder", renderer="buddy:templates/user/confirm_email.mako")
    def confirm_mail_holder(self):
        return dict(title="Confirm your email address")

    @view_config(route_name="login", renderer="buddy:templates/user/login.mako")
    @forbidden_view_config(renderer="buddy:templates/user/login.mako")
    def login(self):
        title = "Login"
        login_url = self.request.route_url('login')
        referrer = self.request.url
        if referrer == login_url:
            referrer = '/myaccount' # never use the login form itself as came_from
        came_from = self.request.params.get('came_from', referrer)
        message = ''
        error_cls=''
        form = Form(self.request,schema=LoginForm)

        if 'form_submitted' in self.request.POST and form.validate():
            '''
            try:
                resp = self.request.POST['g-recaptcha-response']
            except:
                message="Slow network, please solve the challenge"
                return dict(title=title,
                            message = message,
                            form =FormRenderer(form),
                            error_cls = error_cls,
                            url = self.request.application_url + '/login',
                            came_from = came_from)

            recaptcha_r = requests.post(recaptcha_endpoint, dict(secret=buddy_settings('recaptcha_secret'),
                                                                 response=resp))
            rdata = recaptcha_r.json()
            if rdata:
                if not rdata['success']:
                    message="Failed recaptcha, please solve the challenge"
                    error_cls = 'has-error'
                    return dict(title=title,
                                message = message,
                                form =FormRenderer(form),
                                error_cls = error_cls,
                                url = self.request.application_url + '/login',
                                came_from = came_from)
            '''
            email = form.data['email']
            password = form.data['password']
            user=Users.get_by_email(email)
            if Users.check_password(email, password):
                headers = buddy_remember(self.request, user)

                return HTTPFound(location=came_from, headers=headers)
            message = 'Failed login, incorrect email or password, Please try again'
            error_cls = 'has-error'
        return dict(title=title,
                message = message,
                form =FormRenderer(form),
                error_cls = error_cls,
                url = self.request.application_url + '/login',
                came_from = came_from)

    @view_config(permission='post',route_name='logout')
    def logout(self):
        headers = forget(self.request)
        self.session.invalidate()
        return HTTPFound(location=self.request.route_url('home'), headers=headers)

    @view_config(route_name="account", permission="post", renderer="buddy:templates/user/myaccount.mako")
    def acc(self):
        form = Form(self.request)
        title = 'Dashboard'
        user = self.request.user
        usertypes = userTypes()
        listings = DBSession.query(Listings).filter_by(user=user).limit(12).all()
        reflink = self.request.route_url('home') + "?refid=" + user.serial

        return dict(form=FormRenderer(form),title=title,account='account',user=user,listings=listings,
                    usertypes=usertypes, reflink=reflink, states=get_states())

    @view_config(route_name="account-referrals", permission="post", renderer="buddy:templates/user/referral.mako")
    def ref(self):
        title = "My Referrals"
        user = self.request.user
        reflink = self.request.route_url('home') + "?refid=" + user.serial
        page = int(self.request.params.get('page', 1))
        page_url = PageURL_WebOb(self.request)
        paginator = Page(user.children,
                         page=page,
                         items_per_page=20,
                         url=page_url)
        return dict(user=user, title=title, reflink=reflink, paginator=paginator)

    @view_config(route_name="profile", renderer="buddy:templates/user/profile.mako")
    def profile(self):
        form = Form(self.request)
        prefix = self.request.matchdict['prefix']
        user = Users.get_by_path(prefix)
        if not user:
            self.session.flash('warning; No user with the given profile')
            return HTTPFound(location='/')
        total_sales = DBSession.query(Listings).filter_by(user=user).filter(Listings.status==False).count()
        title = user.fullname+"'s"+" profile"
        return dict(user=user,form = FormRenderer(form),
                    title=title,total_sales=total_sales,
                     profile_page="profile_page")

    @view_config(route_name="user_rating")
    def ratings(self):
        form = Form(self.request, schema=UserRatingSchema)
        prefix = self.request.matchdict['prefix']
        user = Users.get_by_path(prefix)
        title = 'Rate '+user.fullname
        if 'form_submitted' in self.request.POST and form.validate():
            if user.id==self.request.user.id:
                self.request.session.flash("danger; You can't rate yourself")
                return HTTPFound(location=self.request.route_url('profile',prefix=prefix))
            if user.rating:
                for rating in user.rating:
                    if rating.rater_id == self.request.user.id:
                        self.request.session.flash("warning; You have rated %s before"%user.fullname)
                        return HTTPFound(location=self.request.route_url('profile',prefix=prefix))
            rating = UserRating(
                rater_id = self.request.user.id,
                rated_id = user.id,
                rating = form.data['rating'],
                review = form.data['review']
            )
            DBSession.add(rating)
            DBSession.flush()
            self.request.session.flash("success; Success")
            return HTTPFound(location = self.request.route_url('profile',prefix=prefix))
        self.request.session.flash("danger; An Error occured")
        return HTTPFound(location = self.request.route_url('profile',prefix=prefix))

    @view_config(route_name="user_ratings_and_reviews", renderer="buddy:templates/user/randr.mako")
    def ratingsandreview(self):
        prefix = self.request.matchdict['prefix']
        form = Form(self.request)
        user = Users.get_by_path(prefix)
        title = user.fullname+"'s"+" Ratings and Reviews"
        ratings = user.rating
        page_url = PageURL_WebOb(self.request)
        paginator = Page(ratings,
                                   page=int(self.request.params.get("page", 1)),
                                   items_per_page=5,
                                   url=page_url)
        return dict(paginator=paginator,user= user,rv='rv', title=title, form=FormRenderer(form),rating_page="rating_page")

    @view_config(route_name="contact_user")
    def contactAgent(self):
        form = Form(self.request, schema = ContactSchema)
        prefix = self.request.matchdict['prefix']
        user = Users.get_by_path(prefix)
        if not user:
            self.session.flash('warning; No such user')
            return HTTPFound(location = '/')
        if 'form_submitted' in self.request.POST and form.validate():

            receiver = user.email
            fullname=form.data['fullname']
            phone=form.data['mobile']
            email = form.data['email']
            body = form.data['body']
            footer="Reply this email to contact the sender"
            msg_body = "%s is requesting to contact you through nairabricks.com\r\n"%fullname +\
                        "Name: %s \n"%fullname+\
                        "Phone: %s\n"%phone+\
                        "Message: %s\n"%body+\
                        "%s"%footer
            sender = "%s via nairabricks.com <info@nairabricks.com>"%fullname
            extra_headers={
            'Reply-To': '{name} <{sender}>'.format(**{'name':fullname,'sender':email}),
        }
            subject = "Contact request from %s via nairabricks.com"%fullname
            non_html_email_sender(self.request,
                                 recipients=receiver,
                                 subject = subject,
                                 body=msg_body,
                                 sender=sender,
                                 extra_headers=extra_headers
                )
            self.request.session.flash("success; Email sent")
            return HTTPFound(location =self.request.route_url('profile',prefix=prefix) )
        self.request.session.flash("success; Email not sent")
        return HTTPFound(location = self.request.route_url('profile',prefix=prefix))

    @view_config(route_name='personal-update',renderer='json', permission='post')
    def update_personal(self):
        user=self.request.user
        form = Form(self.request,schema=PersonalSchema,obj=user)
        if 'personal_submitted' in self.request.POST and form.validate():
            form.bind(user)
            DBSession.add(user)
            if form.data['prefix'] and form.data['prefix']!=user.prefix:
                    user.prefix = create_path(form.data['prefix'], is_unique)
            DBSession.flush()
            if self.request.is_xhr:
                html = """<div class="alert alert-success alert-dismissable col-xs-12">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            Update Successful
                            </div>"""
                return Response(html)
            self.request.session.flash("success; Update successful")
            return HTTPFound(location = self.request.route_url("user_edit"))
        if self.request.is_xhr:
            html = """<div class="alert alert-danger alert-dismissable col-xs-12">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        Update Not Successful
                        </div>"""
            return Response(html)
        self.request.session.flash("success; Update successful")
        return HTTPFound(location=self.request.route_url("user_edit"))

    @view_config(route_name="about-update", renderer='json')
    def abt_update(self):
        user = self.request.user
        form = Form(self.request, schema=NoteSchema, obj=user)
        if "abt_submitted" in self.request.POST and form.validate():
            form.bind(user)
            DBSession.add(user)
            DBSession.flush()
            if self.request.is_xhr:
                html = """<div class="alert alert-success alert-dismissable col-xs-12">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            Update Successful
                            </div>"""
                return Response(html)
            self.session.flash("success; Update successful")
            return HTTPFound(location = self.request.route_url("user_edit"))
        if self.request.is_xhr:
            html = """<div class="alert alert-danger alert-dismissable col-xs-12">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        Update Not Successful
                        </div>"""
            return Response(html)
        self.session.flash("danger; Update Not successful")
        return HTTPFound(location=self.request.route_url("user_edit"))


@view_config(route_name="user_edit", renderer="buddy:templates/user/edit_user.mako",permission="post")
def edit_user(request):
    user = request.user
    form = Form(request)
    title = 'Edit Profile'
    usertypes = userTypes()
    return dict(user=user, form=FormRenderer(form),states=get_states(), title=title, usertypes=usertypes)


@view_config(route_name='user_picture_upload', permission='edit')
def user_pix(request):
    user = request.user
    fileO = request.POST['profile_pix']
    data = StringIO(fileO.file.read())
    resized_data = make_thumbnail(data)
    filename =request.storage.save_file_io(resized_data,fileO.filename,randomize=True,folder="profilepics")
    user.photo = filename
    DBSession.flush()
    return HTTPFound(location=request.route_url("user_edit"))


@view_config(route_name='company_pix_upload', permission='post')
def company_uploadx(request):
    user = request.user
    filename = request.storage.save(request.POST['company_pix'], folder="logos")
    user.company_logo = filename
    DBSession.flush()
    return HTTPFound(location=request.route_url("user_edit"))


@view_config(route_name='cover_pix_upload', permission='edit')
def company_upload(request):
    user = request.user
    fileO = request.POST['cover_pix']
    data = StringIO(fileO.file.read())
    optimized_data = optimize(data)
    filename = request.storage.save_file_io(optimized_data, fileO.filename, randomize=True, folder="coverphotos")
    user.cover_photo = filename
    DBSession.flush()
    return HTTPFound(location=request.route_url("user_edit"))


@view_config(route_name="forgot_password")
def passforgot(request):
    form = Form(request, schema=ForgotPasswordForm)
    if 'form_submitted' in request.POST and form.validate():
        user = Users.get_by_email(form.data['email'])
        if user:
            timestamp = time.time()+3600
            hmac_key = hmac.new('%s:%s:%d' % (str(user.id),
                                'r5$55g35%4#$:l3#24&', timestamp),
                                user.email).hexdigest()[0:10]
            time_key = base64.urlsafe_b64encode('%d' % timestamp)
            email_hash = '%s%s' % (hmac_key, time_key)
            email_forgot(request, user.id, user.email, email_hash)
            request.session.flash('success; Password reset email sent')
            return HTTPFound(location=request.route_url('login'))
        request.session.flash('danger; No user with the given email address')
        return HTTPFound(location=request.route_url('login'))
    request.session.flash('danger; No such user')
    return HTTPFound(location=request.route_url('login'))


@view_config(route_name="change_password", renderer="buddy:templates/changepassword.mako")
def change_pass(request):
    title = "Change your password"
    user = request.user
    username = user.fullname
    changepass_url = request.route_url('change_password')
    referrer = request.url
    if referrer == changepass_url:
        referrer = '/' # never use the change_pass form itself as came_from
    came_from = request.params.get('came_from', referrer)
    form = Form(request, schema=ChangePasswordForm)

    if 'form_submitted' in request.POST and form.validate():
        user.password = form.data['password']
        DBSession.merge(user)
        DBSession.flush()
        return HTTPFound(location=came_from)
    action_url=request.route_url('change_password')
    return {'title':title,'form':FormRenderer(form),'username':username,'user':user,
            'action_url':action_url}


@view_config(route_name='check_oldpassword', renderer='json')
def check_oldpass(request):
    user = request.user
    old_password = request.params.get('old_password')
    if not user.check_password(user.email,old_password):
        return "The password you entered didn't match the old password. Please try again"
    return "true"

@view_config(route_name='check_email', renderer='json')
def check_email(request):
    email = request.params.get('email')
    if Users.get_by_email(email):
        return "The email you entered is already in use"
    return "true"


@view_config(route_name="reset_password", renderer="buddy:templates/user/resetpassword.mako")
def restpass(request):
    title="Reset password"
    submitted_hmac = request.matchdict.get('hmac')
    user_id = request.matchdict.get('user_id')
    form = Form(request, schema = ResetPasswordForm)
    if 'form_submitted' in request.POST and form.validate():
        user = Users.get_by_id(user_id)
        current_time = time.time()
        time_key = int(base64.b64decode(submitted_hmac[10:]))
        if current_time < time_key:
            hmac_key = hmac.new('%s:%s:%d' % (str(user.id),
                                'r5$55g35%4#$:l3#24&', time_key),
                                user.email).hexdigest()[0:10]
            if hmac_key == submitted_hmac[0:10]:
                #Fix me reset email, no such attribute email
                user.password = form.data['password']
                DBSession.merge(user)
                DBSession.flush()
                request.session.flash('success; Password Changed. Please log in')
                return HTTPFound(location=request.route_url('login'))
            else:
                request.session.flash('warning; Invalid request, please try again')
                return HTTPFound(location=request.route_url('forgot_password'))
    action_url = request.route_url("reset_password",user_id=user_id,hmac=submitted_hmac)
    return {'title': title,
            'form': FormRenderer(form), 'action_url': action_url}


@view_config(route_name="email_activate", renderer="buddy:templates/user/confirm_email.mako")
def verify_email(request):
    title="Email Confirmation"
    submitted_hmac = request.matchdict.get('hmac')
    user_id = request.matchdict.get('user_id')
    user = Users.get_by_id(user_id)
    current_time = time.time()
    time_key = int(base64.b64decode(submitted_hmac[10:]))
    if current_time < time_key:
        hmac_key = hmac.new('%s:%s:%d' % (str(user.id),
                                'r5$55g35%4#$:l3#24&', time_key),
                                user.email).hexdigest()[0:10]
        if hmac_key == submitted_hmac[0:10]:
            #Fix me reset email, no such attribute email
            user.email_verified = True
            DBSession.merge(user)
            DBSession.flush()
    if user.email_verified:
        message = 'Your email is now confirmed. Thank you for joining us'
        request.session.flash('success;%s'%message)
        return HTTPFound(location='/')
    else:
        message = 'Error verifying message'
        request.session.flash('success;%s'%message)
        return HTTPFound(location='/')


@view_config(route_name = "email_pass", permission='post')
def email_passw(request):
    user = request.user
    form = Form(request, schema=ChangeEmailPassword, obj=user)
    if 'pass_submitted' in request.POST and form.validate():
        form.bind(user)
        DBSession.add(user)
        DBSession.flush()
        if request.is_xhr:
            html = """<div class="alert alert-success alert-dismissable col-xs-12">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        Update Successful
                        </div>"""
            return Response(html)
        request.session.flash("success; Email and password saved")
        return HTTPFound(location=request.route_url('account'))
    if request.is_xhr:
        html = """<div class="alert alert-danger alert-dismissable col-xs-12">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    Update not Successful {0}
                    </div>""".format(form.all_errors())
        return Response(html)
    request.session.flash("danger; Update not successful")
    return HTTPFound(location=request.route_url('account'))


#################################                   DASHBOARD                ###########################################
@view_config(route_name="add_group",permission='superadmin', renderer="buddy:templates/user/add_group.mako")
def add_g(request):
    title = 'Add group'
    groups = DBSession.query(Groups).all()
    form = Form(request, schema=AddGroup)
    if 'form_submitted' in request.POST and form.validate():
        group = form.bind(Groups())
        DBSession.add(group)
        DBSession.flush()
        redir_url = request.route_url('dashboard')
        return HTTPFound(location=redir_url)
    return dict(form = FormRenderer(form),groups=groups, title=title)



@view_config(route_name='user_log',permission='mod', renderer = "buddy:templates/user/userlog.mako")
def userlog(request):
    users = DBSession.query(AuthUserLog).order_by(AuthUserLog.time.desc()).all()
    title = 'Users logs'
    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(users,
                     page=page,
                     items_per_page=10,
                     url=page_url)
    if page>1:
            title = title+' page '+str(page)
    return dict(paginator=paginator, title=title)


@view_config(route_name="user_list",permission='mod',renderer='buddy:templates/user/userlist.mako')
def userlist(request):


    title = 'User list'


    return dict(title=title)

@view_config(route_name='search_user_list',permission='mod', request_method='GET')
def search_users(request):
    dbsession = DBSession()
    search_term = request.params.get('search','')
    searchstring =  u'%%%s%%' %search_term
    title = "Real Estate Professionals"
    search = dbsession.query(Users).filter(or_(Users.firstname.like(searchstring),
                                               Users.surname.like(searchstring),
                                               Users.company_name.like(searchstring))).order_by(Users.join_date.desc()).all()
    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(search,
                     page=page,
                     items_per_page=12,
                     url=page_url)
    if page>1:
            title = title+' page '+str(page)

    return render_to_response('buddy:templates/user/userlist.mako',
                              dict(paginator=paginator, title=title),request=request)

@view_config(route_name="make_admin", permission='superadmin')
def make_admin(request):
    id = request.matchdict['id']
    user = Users.get_by_id(id)
    pos = request.matchdict['pos']
    group = DBSession.query(Groups).filter(Groups.name==pos).first()
    if user and group:
        try:
            user.mygroups.append(group)
            request.session.flash('success; %s added to group %s'%(user.fullname,group.name))
        except:
            request.session.flash('danger; request not completed')
        return HTTPFound(location=request.route_url('search_user_list'))
    request.session.flash('danger; Not successfull')
    return HTTPFound(location=request.route_url('user_list'))

@view_config(route_name="deny_admin", permission='superadmin')
def deny_admin(request):
    id = request.matchdict['id']
    user = Users.get_by_id(id)
    pos = request.matchdict['pos']
    group = DBSession.query(Groups).filter(Groups.name==pos).first()
    if user and group:
        try:
            user.mygroups.remove(group)
            request.session.flash('success; %s removed from group %s'%(user.fullname,group.name))
        except:
            request.session.flash('danger; Action cannot be performed because %s is not in the group %s' %(user.fullname,group.name))

        return HTTPFound(location=request.route_url('search_user_list'))
    request.session.flash('danger; Not successfull')
    return HTTPFound(location=request.route_url('user_list'))

@view_config(route_name="verify_user", permission='superadmin')
def verify(request):
    prefix = request.matchdict['prefix']
    user = Users.get_by_path(prefix)
    if not user:
        request.session.flash('danger; user not found')
    user.is_verified = True
    user_parent = user.parent
    silver_plan = DBSession.query(Plans).filter(Plans.name=='Silver').first()
    if user_parent:
        if not user_parent.earned_benefit:
            if user.active_subscription:
               active_sub = user.active_subscription[0]
               subscription = Subscription(
                user=user,
                plan=silver_plan,
                amount=0,
                no_of_months=1,
                discount=u"100%",
                status = u"Active")
               subscription.start_date = active_sub.end_date
               subscription.end_date = active_sub.end_date+timedelta(days=30)
            else:
                subscription = Subscription(
                    user=request.user,
                    plan=silver_plan,
                    amount=0,
                    no_of_months=1,
                    discount=u"100%",
                    start_date=datetime.today(),
                    end_date=datetime.today() + timedelta(days=30),
                    status = u"Active"
                )
            DBSession.add(subscription)
            DBSession.flush()
    body = """<html><head><title>Verified on nairabricks.com</title></head><body>
            <p>Dear %s,<p><br>
            <p>You are now verified as a professional in Nairabricks</p>
            <p>However, please note that we still have the right to decline your listings if they violate our property listing policy</p>
            <p>Moreso, ensure that your listings are not duplicated.
            Instead of having duplicate listings, update your listing frequently to keep it at the top</p>
            <p>Yours sincerely,</p>
            <p>The Happy Nairabricks Info Robot</p>
            </body>
            </html>
            """ % user.fullname


    html_email_sender(request,
                     subject="Congratulations",
                     recipients=user.email,
                     body=body
                     )
    request.session.flash('success; user verified')
    return HTTPFound(location = request.route_url('user_list'))

@view_config(route_name="deny_verified", permission='superadmin')
def denyverify(request):
    prefix = request.matchdict['prefix']
    user = Users.get_by_path(prefix)
    if not user:
        request.session.flash('danger; user not found')
    user.is_verified = False
    request.session.flash('success; user verification denied')
    return HTTPFound(location = request.route_url('user_list'))



