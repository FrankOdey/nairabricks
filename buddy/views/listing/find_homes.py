#!/usr/bin/env python
# -*- coding: utf-8 -*-

from pyramid.view import view_config
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.models.properties_model import Listings, State, District, LGA, Property_extras
#from buddy.models.city_model import Locality
from webhelpers.paginate import PageURL_WebOb, Page
from buddy.models import DBSession
from buddy.models.properties_model import PropertyCategory
from buddy.models.resources import Content, Featured_Content, Content_Stat
from buddy.models.user_model import Users, Messages
from buddy.views.listing.schema import MailAgentSchema
from buddy.views.messages import html_email_sender,send_email
from pyramid.httpexceptions import HTTPFound
from pyramid.response import Response
from sqlalchemy import or_, and_
import transaction
import json
import random
from buddy.views.user import userTypes


class ListingView(object):

    def __init__(self, request):
        self.request = request

    @view_config(route_name="rent", renderer = "buddy:templates/listing/property/listing_list.mako")
    def rent(self):
        title = "Properties for rent in Nigeria"
        form = Form(self.request)
        listing = DBSession.query(Listings).filter_by(listing_type='For rent').\
            filter_by(approved = True).filter(Listings.declined==False).\
             filter_by(status=True).order_by(Listings.modified.desc()).all()
        page = int(self.request.params.get("page", 1))
        page_url = PageURL_WebOb(self.request)
        paginator = Page(listing,
                     page=page,item_count=len(listing),
                     items_per_page=10,
                     url=page_url)

        return dict(paginator=paginator, title=title,rent='rent',form=FormRenderer(form),
                    usertypes=userTypes(),
                    type='Rent',
                    min_price = '',
                    max_price = '',
                    state_id = '',
                    lga_id='',
                    lgas=[],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = ''
                    )

    @view_config(route_name="buy", renderer = "buddy:templates/listing/property/listing_list.mako")
    def buy(self):
        form = Form(self.request)
        usertypes = userTypes()
        title="Properties for sale in Nigeria"
        listing = DBSession.query(Listings).filter(Listings.listing_type=='For sale').\
            filter_by(approved = True).filter(Listings.declined==False).\
            filter_by(status=True).order_by(Listings.modified.desc()).all()
        page = int(self.request.params.get("page", 1))
        page_url = PageURL_WebOb(self.request)
        paginator = Page(listing,
                     page=page,item_count=len(listing),
                     items_per_page=10,
                     url=page_url)

        return dict(paginator=paginator, title=title,buy='buy',form=FormRenderer(form),
                    usertypes = usertypes,
                    type='Buy',
                    min_price = '',
                    max_price = '',
                    state_id = '',
                    lga_id='',
                    lgas = [],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = ''
                    )

    @view_config(route_name='cities_autocomplete', renderer='json')
    def autoc(self):
        term = self.request.params.get('cities_auto')
        if term:
            term = '%'+term+'%'
        data = []
        states = DBSession.query(State).filter(State.name.like(term)).all()
        lga = DBSession.query(LGA).filter(LGA.name.like(term)).all()
        district = DBSession.query(District).filter(District.name.like(term)).all()
        for state in states:
            data.append(state.name)
        for lg in lga:
            data.append(lg.name)
        for d in district:
            data.append(d.name)
        return data

    @view_config(route_name="search_properties",renderer="buddy:templates/listing/property/listing_list.mako")
    def search_prop(self):
        form = Form(self.request)
        params = self.request.params
        type = params.get('type')
        no = params.get('listing_no')
        state_id = params.get('state_id')
        lga_id = params.get('lga_id')
        ptype = params.get('property_type')
        min_price = params.get('min_price')
        max_price = params.get('max_price')
        beds = params.get('beds')
        baths = params.get('baths')
        area_size = params.get('area_size')
        covered_area =params.get('covered_area')
        transaction_type =params.get('transaction_type')

        listings = DBSession.query(Listings).join(Property_extras).filter(Listings.approved==True)\
            .filter(Listings.declined==False).filter(Listings.status==True)
        if no:
            listing = DBSession.query(Listings).filter_by(serial=no).filter(Listings.approved==True)\
            .filter(Listings.declined==False).first()
            if listing:
                return HTTPFound(location=self.request.route_url('property_view',name=listing.name))
            title = "Search for listing no: %s"%no
            return dict(paginator=None,title=title, total=0,form=FormRenderer(form))
        if type.lower()=='for sale':
            title = 'Find properties for sale in Nigeria'
            listings = listings.filter(Listings.listing_type=="For sale")

        elif type.lower()=='for rent':
            for_rent="For rent"
            title = 'Find properties for rent in Nigeria'
            listings = listings.filter(Listings.listing_type==for_rent)
        elif type.lower()=='short let':
            short_let="Short let"
            title = 'Find properties for short let in Nigeria'
            listings = listings.filter(Listings.listing_type==short_let)
        else:
            title = "Properties in Nigeria"
        lgas = []
        if state_id:
            state = State.get_by_id(state_id)
            lgas = [(a.id,a.name) for a in state.lga.all()]
            listings = listings.filter(Listings.state_id==state_id)
            if type.lower()=='for sale':
                title = "Properties for sale in %s"%state.name
            elif type.lower()=='for rent':
                title = "Properties for rent in %s"%state.name
            elif type.lower()=='short let':
                title = "Properties for short let in %s"%state.name
            else:
                title = "Properties in %s"%state.name
        if lga_id:
            lga = LGA.get_by_id(lga_id)
            listings = listings.filter(Listings.lga_id==lga_id)
            if type.lower()=='for sale':
                title = "Properties for sale in %s,%s"%(lga.name,lga.state.name)
            elif type.lower()=='for rent':
                title = "Properties for rent in %s,%s"%(lga.name,lga.state.name)
            elif type.lower()=='short let':
                title = "Properties for short let in %s,%s"%(lga.name,lga.state.name)
            else:
                title = "Properties in %s,%s"%(lga.name,lga.state.name)
        if ptype:
            category = PropertyCategory.get_by_id(ptype)
            listings = listings.filter(Listings.category_id==ptype)
            if lga_id:
                lga = LGA.get_by_id(lga_id)
                if type.lower()=='for sale':

                    title = "%s for sale in %s,%s"%(category.name,lga.name,lga.state.name)
                elif type.lower()=='for rent':
                    title = "%s for rent in %s,%s"%(category.name,lga.name,lga.state.name)
                elif type.lower()=='short let':
                    title = "%s for short let in %s,%s"%(category.name,lga.name,lga.state.name)
                else:
                    title = "%s in %s,%s"%(category.name,lga.name,lga.state.name)
            elif state_id:
                state = State.get_by_id(state_id)
                if type.lower()=='for sale':
                    title = "%s for sale in %s"%(category.name,state.name)
                elif type.lower()=='for rent':
                    title = "%s for rent in %s"%(category.name,state.name)
                elif type.lower()=='short let':
                    title = "%s for short let in %s"%(category.name,state.name)
                else:
                    title = "%s in %s"%(category.name,state.name)
        if min_price:
            value =str(min_price[2:])
            value = ''.join([i for i in value if i.isdigit()])
            listings = listings.filter(Listings.price>=int(value))
        if max_price:
            value =str(max_price[2:])
            value = ''.join([i for i in value if i.isdigit()])
            listings = listings.filter(Listings.price<=int(value))
        if beds:
            listings=listings.filter(Property_extras.bedroom>=beds)
        if baths:
            listings = listings.filter(Property_extras.bathroom>=baths)
        if area_size:
            listings = listings.filter(Property_extras.area_size>=area_size)
        if covered_area:
            listings = listings.filter(Property_extras.covered_area>=covered_area)
        if transaction_type:
            listings = listings.filter(Listings.transaction_type==transaction_type)
        premium = listings.filter(Listings.featured).all()
        if not premium:
            premium =[]

        listings = listings.order_by(Listings.modified.desc()).all()
        listings = [i for i in listings if i not in premium]
        listings = premium+listings
        page = int(self.request.params.get("page", 1))
        page_url = PageURL_WebOb(self.request)
        paginator = Page(listings,
                     page=page,item_count=len(listings),
                     items_per_page=10,
                     url=page_url)


        return dict(paginator=paginator,
                    form = FormRenderer(form),
                    title=title, total=len(listings),
                    type=type,
                    min_price = min_price,
                    max_price = max_price,
                    state_id = state_id,
                    lga_id = lga_id,
                    lgas = lgas,
                    ptype = ptype,
                    beds = beds,
                    baths = baths,
                    area_size = area_size,
                    covered_area = covered_area,
                    transaction_type = transaction_type
        )

    @view_config(route_name="property_view", renderer="buddy:templates/listing/property/view.mako")
    def view_p(self):
        name = self.request.matchdict['name']
        listing = Listings.get_by_name(name)
        if not listing:
            self.request.session.flash('warning; Listing not found')
            return HTTPFound(location=self.request.route_url('home'))
        form = Form(self.request)
        files = listing.pictures.all()
        #city = DBSession.query(Locality).filter(Locality.state_id==listing.state_id).\
        #    filter(Locality.city_name==listing.city).first()
        category = listing.property_extra

        '''
        receiver = listing.user.email
        body = """
        <html><head></head><body>
        <p>Dear %s,<p><br>

        <p>A user at Nairabricks viewed your property <a href="%s">%s</a> just now.</p>

        <p>Yours sincerely,</p>
        <p>The Happy Nairabricks Info Robot</p>
        </body>
        </html>
        """%(listing.user.fullname,self.request.route_url('property_view',name=name),listing.serial)
        if not self.request.user==listing.user:
            html_email_sender(self.request,
            subject = "Property Clicks",
            recipients=receiver,
            body = body
        )
        '''
        view_log = Content_Stat(
            content_id = listing.id,
            views =1
        )
        DBSession.add(view_log)
        DBSession.flush()


        return dict(files=files,title=listing.title,
                    form=FormRenderer(form),
                    category=category,
                    listing=listing
                    #, locality=city
        )

    @view_config(route_name = "user_listings",renderer = "buddy:templates/listing/property/userlisting.mako" ,http_cache=3600)
    def user_listing(self):
        form = Form(self.request)
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        page = int(self.request.params.get("page", 1))
        page_url = PageURL_WebOb(self.request)
        active_listings = DBSession.query(Listings).filter(Listings.user == user).filter(Listings.approved==True).\
            filter(Listings.declined==False).filter(Listings.status==True).all()
        past_sales = DBSession.query(Listings).filter(Listings.user==user).filter(Listings.status==False).all()

        active_paginator = Page(active_listings,
                                page=int(self.request.params.get("page", 1)),
                                items_per_page=10,
                                url=page_url)
        pastsales_paginator = Page(past_sales,
                                   page=int(self.request.params.get("page", 1)),
                                   items_per_page=10,
                                   url=page_url)
        title=user.fullname + "'s Listings"

        return dict(user=user,pastsales_paginator=pastsales_paginator,lis="d",
                    form = FormRenderer(form),active_paginator=active_paginator, title=title)

    @view_config(route_name="account-listings", renderer="buddy:templates/listing/property/mylistings.mako",
                 http_cache=3600, permission='post')
    def account_listing(self):
        form = Form(self.request)
        user = self.request.user
        page = int(self.request.params.get("page", 1))
        page_url = PageURL_WebOb(self.request)
        active_listings = DBSession.query(Listings).filter(Listings.user == user).filter(Listings.approved == True). \
            filter(Listings.declined == False).filter(Listings.status == True).all()
        onreview_listings = DBSession.query(Listings).filter(Listings.user == user).filter(Listings.approved == False). \
            filter(Listings.declined == False).filter(Listings.status == True).all()
        declined_listings = DBSession.query(Listings).filter(Listings.user == user). \
            filter(Listings.declined == True).filter(Listings.status == True).all()
        past_sales = DBSession.query(Listings).filter(Listings.user == user).filter(Listings.status == False).all()
        favourites = user.favourites
        active_paginator = Page(active_listings,
                                page=int(self.request.params.get("page", 1)),
                                items_per_page=10,
                                url=page_url)
        declined_paginator = Page(declined_listings,
                                  page=int(self.request.params.get("page", 1)),
                                  items_per_page=10,
                                  url=page_url)
        pastsales_paginator = Page(past_sales,
                                   page=int(self.request.params.get("page", 1)),
                                   items_per_page=10,
                                   url=page_url)
        onreview_paginator = Page(onreview_listings,
                                  page=int(self.request.params.get("page", 1)),
                                  items_per_page=10,
                                  url=page_url)
        favourite_paginator = Page(favourites,
                                   page=int(self.request.params.get("page", 1)),
                                   items_per_page=10,
                                   url=page_url)
        title = user.fullname + "'s Listings"
        if page > 1:
            title = title + ' page ' + str(page)
        return dict(user=user, pastsales_paginator=pastsales_paginator, onreview_paginator=onreview_paginator,
                    form=FormRenderer(form), active_paginator=active_paginator, declined_paginator=declined_paginator,
                    title=title, favourites_paginator=favourite_paginator)


    @view_config(route_name="all_property_listing",
                 renderer="buddy:templates/listing/property/listing_list.mako", http_cache=173200)
    def all_listing(self):
        form = Form(self.request)
        usertypes = userTypes()
        title = 'Properties for sale and rent in Nigeria'
        page = int(self.request.params.get('page', 1))
        paginator = Listings.get_paginator(self.request,page)
        pastsales = DBSession.query(Listings).filter(Listings.approved==True).\
            filter(Listings.declined==False).filter(Listings.status==False).all()
        page_url = PageURL_WebOb(self.request)
        pastsales_paginator = Page(pastsales,
                                   page=int(self.request.params.get("page", 1)),
                                   items_per_page=5,
                                   url=page_url)

        self.request.response.cache_control.prevent_auto = True
        return dict(paginator = paginator, find='all',form=FormRenderer(form),usertypes = usertypes,
                    title=title, pastsales_paginator=pastsales_paginator,
                    type='',
                    min_price = '',
                    max_price = '',
                    state_id = '',
                    lga_id='',
                    lgas=[],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = ''
                    )
    @view_config(route_name="delete_listing", permission="superadmin")
    def delete(self):
        id = self.request.matchdict['id']
        listing = Listings.get_by_id(id)
        if listing:
            DBSession.delete(listing)
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('home'))
        else:
            self.request.session.flash("warning; Listing not found")
            return HTTPFound(location = '/')

    @view_config(route_name="approve_listing", renderer="json", permission="admin")
    def approve(self):

        params = self.request.params
        id = params['id']
        listing = Listings.get_by_id(id)
        if listing:
            listing.approved = True
            listing.declined = False
            DBSession.flush()

            body = """<html><head></head><body>
                    <p>Dear %s,<p><br>

                    <p>Your Listing <a href="%s">%s</a> at Nairabricks has just been approved.</p>

                    <p>Yours sincerely,</p>
                    <p>The Happy Nairabricks Info Robot</p>
                    </body>
                    </html>
                    """%(listing.user.fullname,self.request.route_url('property_view',name=listing.name),listing.serial)
            html_email_sender(self.request,
                subject = "Listing %s Approved"%listing.serial,
                recipients=listing.user.email,
                body = body
                )
            return dict(isOk=1, message="Listing approved")
        return dict(isOk=0, message = "No such listing")

    @view_config(route_name="decline_listing", renderer="json")
    def decline(self):
        params = self.request.params
        id = params['id']
        listing = Listings.get_by_id(id)
        if listing:
            listing.declined = True
            listing.approved = False
            DBSession.flush()
            body = """<html><head></head><body>
                    <p>Dear %s,<p><br>

                    <p>Your Listing <a href="%s">%s</a> at Nairabricks has just been declined.</p>
                    <p>This might be because  of any of the following:</p>
                    <ul>
                    <li>Inaccurate Price</li>
                    <li>Incomplete Address</li>
                    <li>Property Description</li>
                    <li>Duplicate Property</li>
                    <li>Lack of basic user profile details e.g profile picture, address etc</li>
                    <li>it has a logo watermark from another website.</li>
                    </ul>
                    <p>Update your listing so that it can be approved</p>
                    <p>Yours sincerely,</p>
                    <p>The Happy Nairabricks Info Robot</p>
                    </body>
                    </html>
                    """%(listing.user.fullname,self.request.route_url('property_view',name=listing.name),listing.serial)
            html_email_sender(self.request,
                subject = "Listing %s Declined"%listing.serial,
                recipients=listing.user.email,
                body = body
                )
            return dict(isOk=1, message="Declined")
        return dict(isOk=0, message = "No such listing")

    @view_config(route_name="mark_as_sold", renderer="json")
    def markassold(self):
        params = self.request.params
        token = params['token']
        id = params['id']
        price = params['price']
        price =str(price[2:])
        price = ''.join([i for i in price if i.isdigit()])
        if len(price)<3:
            return dict(isOk=0,message="Enter price value")
        listing = Listings.get_by_id(id)
        if listing and (token==self.request.session.get_csrf_token()):
            listing.sold_price = price
            listing.status=False
            DBSession.flush()
            return dict(isOk=1, message="Success")
        return dict(isOk=0, message = "No such listing")

    @view_config(route_name="make_premium_listing", renderer="json", permission="post")
    def make_premium(self):
        for r in self.request.params:
            opts = r
        params = json.loads(opts)

        id = params['id']
        user_id = params['user_id']
        user = Users.get_by_id(user_id)
        positive = params['positive']
        listing = Listings.get_by_id(id)

        if listing:
            if int(positive)==1:
                #we already have it as premium, remove
                premium =DBSession.query(Featured_Content).filter(Featured_Content.name=='Premium').first()
                premium.featured_properties.remove(listing)
                DBSession.flush()
                return dict(isOk=1, message="listing removed from premium")
            else:
                active_sub = user.active_subscription
                if not active_sub:
                    return dict(isOk=0, message="Upgrade your account to feature this listing")
                premium =DBSession.query(Featured_Content).filter(Featured_Content.name=='Premium').first()
                if premium.featured_properties:
                    user_total_premium=0
                    for item in premium.featured_properties:
                        if item.user == user:
                            user_total_premium +=1
                    if user_total_premium < active_sub[0].plan.max_premium_listings:
                        premium.featured_properties.append(listing)
                        DBSession.flush()
                        return dict(isOk=1, message="listing given a premium identity")
                    return dict(isOk=0, message="You have exceeded your allocation. Upgrade for more")
                premium.featured_properties.append(listing)
                DBSession.flush()
                return dict(isOk=1, message="listing given a premium identity")

        return dict(isOk=0, message = "No such listing")


    @view_config(route_name="add_to_favourites", renderer="json")
    def makefavourites(self):
        for r in self.request.params:
            opts=r
        params = json.loads(opts)
        listing = Listings.get_by_id(params['id'])
        positive = params['positive']
        if listing:
            user = self.request.user
            if int(positive)==1:
                user.favourites.remove(listing)
                DBSession.flush()
                return dict(isOk=1, message='Property removed from favourite')
            else:
                user.favourites.append(listing)
                DBSession.flush()
                return dict(isOk=1, message='Property saved')
        return dict(isOk=0, message="Please try again")

    @view_config(route_name="favourite_properties",renderer="buddy:templates/user/favourite_properties.mako")
    def user_favourites(self):
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        form = Form(self.request)
        listings = user.favourites
        title="%s Saved Properties"%user.fullname
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get("page", 1))
        paginator = Page(listings,
                     page=page,
                     items_per_page=10,
                     url=page_url)


        return dict(user=user,paginator=paginator,form=FormRenderer(form),saved='saved',
                    title=title)

@view_config(route_name="mail_agents")
def emailage(request):
    camefrom = request.params.get('camefrom')
    listing = Listings.get_by_name(camefrom)
    form=Form(request, schema=MailAgentSchema)
    if 'submit' in request.POST and form.validate():

        receiver = listing.user.email
        name = form.data['fullname']
        phone=form.data['mobile']
        email = form.data['email']
        sender = "%s via nairabricks.com <info@nairabricks.com>"%name
        subject = "Contact Request from %s via nairabricks.com"%name
        content="<p>I am Interested in your listing at nairabricks.com. I will like to know more about %s in %s. Please get in touch with me</p>"%(listing.title,listing.address)
        footer = "<small>Phone: %s</small>"%phone+"<br/>"
        msg_body = "<html><head><title>"+subject+"</title></head><body>"+\
            "Concerning listing Number %s"%listing.serial +\
            "<br/>%s <br/>%s"%(content,footer)+\
            "</body></html>"
        extra_headers={
            "Reply-To": '%s <%s>'%(name, email)
        }
        html_email_sender(request,
                             recipients=receiver,
                             subject = subject,
                             body=msg_body,
                             sender=sender,
                             extra_headers=extra_headers
            )
        if request.is_xhr:
            html = """<div class="alert alert-success alert-dismissable col-xs-12">
	        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            Email Sent
            </div>"""
            return Response(html)
        request.session.flash("success; Email sent")
        return HTTPFound(location=request.route_url('property_view',name=camefrom))
    if request.is_xhr:
        html = """<div class="alert alert-success alert-dismissable col-xs-12">
	 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
Email not sent
</div>"""
        return Response(html)
    request.session.flash("danger; Email not sent")
    return HTTPFound(location=request.route_url('property_view',name=camefrom))



@view_config(route_name="browse_state", renderer=
             "buddy:templates/listing/property/listing_list.mako")
def from_state(request):
    state_name = request.matchdict['state_name']
    state = State.get_by_name(state_name)
    listings=DBSession.query(Listings).filter(Listings.approved==True).\
    filter(Listings.declined==False).filter(Listings.state==state).order_by(Listings.modified.desc()).all()
    page_url = PageURL_WebOb(request)
    page=int(request.params.get("page", 1))
    paginator = Page(listings,
                     page=page,
                     items_per_page=10,
                     url=page_url)
    title = "Properties in %s"%(state_name)
    form = Form(request)
    return dict(title=title,form = FormRenderer(form),paginator=paginator,state=state,
                type='',
                    min_price = '',
                    max_price = '',
                    state_id = state.id,
                    lga_id='',
                    lgas=[(a.id,a.name) for a in state.lga.all()],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = ''

    )

@view_config(route_name="browse_region", renderer=
             "buddy:templates/listing/property/listing_list.mako")
def from_region(request):
    region_id = request.matchdict['region_id']
    lga = LGA.get_by_id(region_id)
    listings=DBSession.query(Listings).filter(Listings.approved==True)\
    .filter(Listings.declined==False).filter(Listings.lga==lga).order_by(Listings.modified.desc()).all()
    page_url = PageURL_WebOb(request)
    page=int(request.params.get("page", 1))
    paginator = Page(listings,
                     page=page,
                     items_per_page=5,
                     url=page_url)
    title = "Properties in %s,%s"%(lga.name,lga.state.name)

    form = Form(request)
    return dict(title=title, paginator=paginator,lga=lga,
                form = FormRenderer(form),
                type='',
                    min_price = '',
                    max_price = '',
                    state_id = lga.state.id,
                    lga_id=lga.id,
                    lgas=[(a.id,a.name) for a in lga.state.lga.all()],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = '')

@view_config(route_name="browse_area", renderer=
             "buddy:templates/listing/property/listing_list.mako")
def from_area(request):
    area_id = request.matchdict['area_id']
    district = District.get_by_id(area_id)
    listings=DBSession.query(Listings).filter(Listings.approved==True).\
    filter(Listings.declined==False).filter(Listings.district==district).order_by(Listings.modified.desc()).all()
    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(listings,
                     page=page,
                     items_per_page=5,
                     url=page_url)
    form = Form(request)
    title = "Properties in %s, %s,%s"%(district.name,district.lga.name,district.lga.state.name)

    return dict(title=title, paginator=paginator,district=district,
                form = FormRenderer(form),
                type='',
                    min_price = '',
                    max_price = '',
                    state_id = district.lga.state.id,
                    lga_id=district.lga.id,
                    lgas=[(a.id,a.name) for a in district.lga.state.lga.all()],
                    ptype = '',
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = '')

@view_config(route_name="browse_category", renderer=
             "buddy:templates/listing/property/listing_list.mako")
def from_category(request):
    c_id = request.matchdict['category_id']
    category = PropertyCategory.get_by_id(c_id)
    if category.parent:
        title = "%s in Nigeria"%(category.name)
        ptype=category.id
        listings=DBSession.query(Listings).filter(Listings.approved==True).filter(Listings.declined==False).\
        filter(Listings.category==category).order_by(Listings.modified.desc()).all()
    else:
        ptype=''
        title = "%s Properties in Nigeria"%(category.name)
        category_children = [x.name for x in category.children]
        listings = DBSession.query(Listings).join(PropertyCategory).filter(Listings.approved==True).\
        filter(Listings.declined==False).filter(PropertyCategory.name.in_(category_children)).order_by(Listings.modified.desc()).all()
    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(listings,
                     page=page,
                     items_per_page=10,
                     url=page_url)

    form = Form(request)
    return dict(title=title, paginator=paginator,category=category,
                form = FormRenderer(form),
                type='',
                    min_price = '',
                    max_price = '',
                    state_id = '',
                    lga_id='',
                    lgas=[],
                    ptype = ptype,
                    beds = '',
                    baths = '',
                    area_size = '',
                    covered_area = '',
                    transaction_type = '')