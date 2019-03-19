#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
from cStringIO import StringIO
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from webhelpers.paginate import PageURL_WebOb, Page
from buddy.utils.tools import CSRFSchema
from buddy.utils.url_normalizer import urlify_name
from buddy.views.advice.schema import BlogPost
from buddy.models.resources import Content, Content_Stat
from buddy.models.blogs_model import Blogs,BlogCategory
from buddy.models import DBSession
from buddy.models.user_model import Users
from buddy.pyramid_storage.exceptions import FileNotAllowed
import colander, deform

def get_categories():
    p = DBSession.query(BlogCategory).all()
    d=[]
    for category in p:
        if category.children:
            f=[(child.id, child.name) for child in category.children]
            f=f,category.name
            d.append(f)
    return d


def get_navcategories():
    return DBSession.query(BlogCategory).all()

desc = "Nairabricks RealEstate Blog aims to provide a platform where " \
               "realestate professionals will educate the masses on various " \
               "issues concerning realestate. At the same time, realestate " \
               "professionals promote themselves with their write up. "

def histogram(bcategories):
    d=dict()
    for list_item in bcategories:
        for category in list_item:
            if category.name not in d:
                d[(category.name)] = 1
            else:
                d[(category.name)] += 1
    return d


class BlogView(object):
    def __init__(self,request):
        self.request = request
        self.session=request.session
    '''
    @view_config(route_name="voices", renderer="buddy:templates/blog/voices.mako", http_cache=3600)
    def voice(self):
        form = Form(self.request)
        title = "Voices"
        voices_q = with_polymorphic(Content,[Blogs,Questions])
        query = DBSession.query(voices_q).order_by(random.choice([Content.created.desc(),
                                                                  Content.title])).all()
        page_url = PageURL_WebOb(self.request)
        paginator = Page(query,
                     page=int(self.request.params.get("page", 1)),
                     url=page_url)
        return dict(title=title,form=FormRenderer(form),paginator=paginator)
    '''

    @view_config(route_name="add_blog",renderer="buddy:templates/blog/new.mako")
    def add_blog(self):

        title = "Write a blog post"

        user = self.request.user
        if user is None:
            self.request.session.flash('info; Not signed in, Please sign in')
            return HTTPFound(location = self.request.route_url('login'))

        if not self.request.user.email_verified:
            return HTTPFound(location=self.request.route_url('confirm_mail_holder'))
        dbsession=DBSession()
        from deform.widget import OptGroup
        def get_categories_inside():
            p = DBSession.query(BlogCategory).all()
            c=[]
            for category in p:
                if category.children:
                    g=[category.name]
                    d=[(child.id, child.name) for child in category.children]
                    for i in d:
                        g.append(i)
                    c.append(OptGroup(*tuple(g)))
            return c

        choices = tuple(get_categories_inside())

        class BlogSchema(CSRFSchema):
            title = colander.SchemaNode(
                colander.String(),
                title = "Title of blog post",
                widget = deform.widget.TextInputWidget(css_class="form-control required")
            )
            category_id = colander.SchemaNode(
                colander.Set(),
                title = "Categorize your blog post",
                widget = deform.widget.SelectWidget(values=choices,
                    multiple=True,css_class="required")
            )
            body = colander.SchemaNode(
                colander.String(),
                title = "Body",
                widget = deform.widget.TextAreaWidget(css_class="required", id="editor",rows="10")
            )

            #state_id = colander.SchemaNode(
           #     colander.String(),
           #     title = "State",
           #     missing=u'',
           #     widget = deform.widget.SelectWidget(values=get_states(),
          #          css_class="required")
           # )

           # city = colander.SchemaNode(
           #     colander.String(),
           #     title = "City",
           #     missing=u'',
           #     widget = deform.widget.TextInputWidget(css_class="required")
          #  )
        def validator(form, value):

            if  len(value['category_id'])>8:
                exc = colander.Invalid(form, 'Categories must be less than 8')
                exc['category_id'] = 'Categories must be less than 8'
                raise exc


        button = deform.Button(name="submit", title="Publish",css_class="btn btn-primary pull-right")
        button2 = deform.Button(name="draft", title="Save as Draft", css_class="btn btn-warning pull-left")

        schema = BlogSchema(validator=validator).bind(request=self.request)
        rform = deform.Form(schema, buttons=(button,button2),bootstrap_form_style='form-horizontal')
        form = rform.render()

        if 'submit' in self.request.POST:
            controls = self.request.POST.items() # get the form controls

            try:
                appstruct = rform.validate(controls)  # call validate
            except deform.ValidationFailure, e:
                return {'form':e.render(), 'title':title}
            blog = Blogs(
                user = self.request.user,
                 name = urlify_name(appstruct['title']),
                title = appstruct['title'],
                body = appstruct['body']
                #state_id = appstruct['state_id']
                #city = appstruct['city']
             )
            for category in appstruct['category_id']:
                t = DBSession.query(BlogCategory).get(category)
                blog.categories.append(t)
            blog.status=True
            dbsession.add(blog)
            #non_html_email_sender(
            #    self.request,
            #    recipients=["info@nairabricks.com"],
            #    subject="Blog post added on site",
            #    body="A user published a blog right now"
            #)
            dbsession.flush()
            return HTTPFound(location=self.request.route_url('blog_view',
                                                                    name=blog.name))
        elif 'draft' in self.request.POST:
            controls = self.request.POST.items() # get the form controls

            try:
                appstruct = rform.validate(controls)  # call validate
            except deform.ValidationFailure, e:
                return {'form':e.render(), 'title':title}
            blog = Blogs(
                user = self.request.user,
                 name = urlify_name(appstruct['title']),
                title = appstruct['title'],
                body = appstruct['body'],
                status = 0
                #state_id = appstruct['state_id']
                #city = appstruct['city']
             )
            for category in appstruct['category_id']:
                t = DBSession.query(BlogCategory).get(category)
                blog.categories.append(t)
            blog.status = False
            dbsession.add(blog)
            #non_html_email_sender(
            #    self.request,
            #    recipients=["info@nairabricks.com"],
            #    subject="A blog drafted right now",
            #    body="A user drafted a blog post just now"
            #)
            dbsession.flush()
            return HTTPFound(location =self.request.route_url('blog_view', name=blog.name))
        page = int(self.request.params.get('page', 1))
        paginator = Blogs.get_paginator(self.request, page,published=False)
        return {'title':title,
                'wb':'wb',"drafts":paginator,
                'form':form}
    
    @view_config(route_name = 'edit_blog', permission='post',
                 renderer="buddy:templates/blog/edit.mako")
    def edit_blog(self):
        from buddy.models.properties_model import State
        def get_states():
            query = [(s.id,s.name) for s in DBSession.query(State).all()]
            return query
        name = self.request.matchdict['name']
        categories = get_categories()
        blog = Blogs.get_by_name(name)
        if not blog:
            self.session.flash("danger; No such blog post")
            return HTTPFound(location=self.request.route_url('blog_list'))
        title = "Editing " + blog.title
        form = Form(self.request,schema = BlogPost, obj = blog)
        if "form_submitted" in self.request.POST and form.validate():
            form.bind(blog, exclude=['category_id'])
            for i, cat in enumerate(blog.categories):
                if cat.id not in form.data['category_id']:
                    del blog.categories[i]
            catids = [cat.id for cat in blog.categories]
            for cate in form.data['category_id']:
                if cate not in catids:
                    t = DBSession.query(BlogCategory).get(cate)
                    blog.categories.append(t)
            blog.status = True
            DBSession.add(blog)
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('blog_view',
                                                                    name=blog.name))
        elif "draft" in self.request.POST and form.validate():
            form.bind(blog, exclude=['category_id'])
            for i, cat in enumerate(blog.categories):
                if cat.id not in form.data['category_id']:
                    del blog.categories[i]
            catids = [cat.id for cat in blog.categories]
            for cate in form.data['category_id']:
                if cate not in catids:
                    t = DBSession.query(BlogCategory).get(cate)
                    blog.categories.append(t)
            blog.status=0
            DBSession.add(blog)
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('blog_view',
                                                                    name=blog.name))

        return {'form':FormRenderer(form),'blog_nav_cat':get_navcategories(),
                'title':title,'categories':categories,'blog':blog,'wb':'wb','states':get_states()}
    
    @view_config(route_name="blog_list",renderer='buddy:templates/blog/list.mako')
    def blog_list(self):
        title = 'Real Estate Professionals Blog Posts'
        form = Form(self.request)
        categories= get_navcategories()
        page = int(self.request.params.get('page', 1))
        paginator = Blogs.get_paginator(self.request, page,published=True)

        if page>1:
            title = title+' page '+str(page)
        return {'paginator':paginator,'form':FormRenderer(form),
                'title':title,'blog_nav_cat':categories}

    @view_config(route_name="draft_list",renderer='buddy:templates/dashboard/draft.mako',permission='admin')
    def draft_list(self):
        title = 'Drafts'
        form = Form(self.request)
        categories= get_navcategories()
        page = int(self.request.params.get('page', 1))
        paginator = Blogs.get_paginator(self.request, page,published=False)
        if page>1:
            title = title+' page '+str(page)
        return {'paginator':paginator,'form':FormRenderer(form),
                'title':title,'blog_nav_cat':categories, "page_description":desc}

    @view_config(route_name = 'blog_category_filter', 
                renderer="buddy:templates/blog/list.mako")
    def filterd(self):
        categories = get_navcategories()
        id = self.request.matchdict['id']
        cate = BlogCategory.get_by_id(id)

        title = cate.name
        query = DBSession.query(Blogs). \
              filter(Blogs.categories.any(name=cate.name)).all()
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get('page', 1))
        paginator = Page(query, 
                     page=page,
                     url=page_url)
        if page>1:
            title = title+' page '+str(page)
        return {'paginator':paginator,'title':title,
                'blog_nav_cat':categories,"page_description":desc,'bcategory':cate}


        
    @view_config(route_name="blog_view", renderer="buddy:templates/blog/view.mako")
    def view_blog(self):
        name = self.request.matchdict['name']
        blog = Blogs.get_by_name(name)
        if not blog:
            self.session.flash("danger; No such blog post")
            return HTTPFound(location=self.request.route_url('blog_list'))
        title = blog.title
        bcategor = DBSession.query(Blogs).filter(Blogs.user_id==blog.user.id).all()
        bc=[s.categories for s in bcategor]
        bc = histogram(bc)
        view_log = Content_Stat(
            content_id = blog.id,
            views =1
        )
        DBSession.add(view_log)

        DBSession.flush()
        return dict(blog=blog,user=blog.user,title=title,blog_nav_cat=get_navcategories(),
                     bcategories=bc)

    @view_config(route_name="user_blog", renderer="buddy:templates/blog/userblog.mako")
    def userblog(self):
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        blogs = DBSession.query(Blogs).filter(Blogs.user==user).filter(Blogs.status==True).all()
        form = Form(self.request)
        title=user.fullname + "'s Blogs"
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get('page', 1))
        paginator = Page(blogs,
                     page=page,
                     url=page_url)
        return dict(user=user,paginator=paginator,
                    form=FormRenderer(form),bl='bl', title=title)

    @view_config(route_name="account-blogs", renderer="buddy:templates/blog/myblogs.mako")
    def accountblog(self):
        user = self.request.user
        blogs = DBSession.query(Blogs).filter(Blogs.user == user).filter(Blogs.status == True).all()
        drafts = DBSession.query(Blogs).filter(Blogs.user == user).filter(Blogs.status == False).all()
        form = Form(self.request)
        title = "My Blog post"
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get('page', 1))
        postpaginator = Page(blogs,
                         page=page,
                        item_per_page=10,
                         url=page_url)
        draftpaginator = Page(drafts,
                             page=page,
                              item_per_page=10,
                             url=page_url)
        return dict(user=user, postpaginator=postpaginator, draftpaginator=draftpaginator,
                    form=FormRenderer(form),title=title)

    @view_config(route_name="user_drafts", renderer="buddy:templates/blog/userdraft.mako")
    def userdraft(self):
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        blogs = DBSession.query(Blogs).filter(Blogs.user==user).filter(Blogs.status==False).all()
        bc=[s.categories for s in blogs if s.status==0]
        bc = histogram(bc)
        form = Form(self.request)
        title='Drafts'
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get('page', 1))
        paginator = Page(blogs,
                     page=page,
                     url=page_url)
        if page>1:
            title = title+' page '+str(page)
        return dict(user=user,paginator=paginator,bl='bl',form=FormRenderer(form), title=title, bcategories=bc)

    @view_config(route_name="user_blog_filter", renderer="buddy:templates/blog/userblog.mako")
    def userblogfilter(self):
        path= self.request.matchdict['prefix']
        form = Form(self.request)
        #id = self.request.matchdict['id']
        category = self.request.matchdict['category']
        user = Users.get_by_path(path)
        blogs = user.content.filter(Content.type=='blog').filter(Blogs.categories.any(name=category)).all()
        bcategor = user.content.filter(Content.type=='blog').filter(Blogs.user_id==user.id).all()
        bc=[s.categories for s in bcategor]
        bc = histogram(bc)
        title=user.fullname + "'s Blogs on "+ category
        page_url = PageURL_WebOb(self.request)
        page = int(self.request.params.get('page', 1))
        paginator = Page(blogs,
                     page=page,
                     url=page_url)
        if page>1:
            title = title+' page '+str(page)
        return dict(user=user,paginator=paginator,blog_nav_cat=get_navcategories(),
                    form=FormRenderer(form),bl='bl',category=category, title=title, bcategories=bc)

    @view_config(route_name="blog_delete", permission='superadmin')
    def delete(self):
        name = self.request.matchdict['name']
        blog = Blogs.get_by_name(name)
        user=blog.user
        if not blog:
            self.session.flash("warning; no such blog")
            return HTTPFound(location=self.request.route_url('blog_list'))
        body = '''<html><head></head><body>
                    <p>Dear %s,<p><br>

                    <p>Your blog post <a href="%s">%s</a> have just been deleted. This might be because of self promotion,
                    abuse or outright violation of our good neighbor policy</p>
                    <p>Please, you are only allowed to write articles that will help our community</p>

                    <p>Yours sincerely,<br>
                    The Happy Nairabricks Info Robot</p>
                    </body>
                    </html>
                    '''%(user.fullname,self.request.route_url('blog_view', name=blog.name),blog.title)
        #html_email_sender(self.request,
        #        subject = "Blog Post deleted",
        #        recipients=user.email,
        #        body = body
        #        )
        DBSession.delete(blog)
        DBSession.flush()

        self.session.flash("success;  blog_deleted")
        return HTTPFound(location=self.request.route_url('blog_list'))


    @view_config(route_name="image_upload", renderer="json")
    def imageupload(self):
        from buddy.views.listing.add import optimize
        try:
            fileO = self.request.POST["file"]
            data = StringIO(fileO.file.read())
            optimized_data = optimize(data)
            filename = self.request.storage.save_file_io(optimized_data, fileO.filename,
                                                         randomize=True, folder="%s"%self.request.user.id)
        except FileNotAllowed:
            return dict(error = "File not allowed")
        path = self.request.storage.url(filename)

        return dict(link=path)

    @view_config(route_name="image_delete",renderer="json")
    def imagedelete(self):
        url = self.request.POST["src"]
        url = url.split('/')[-1]
        filedeleted = self.request.storage.delete(url)
        if filedeleted:
            return dict(success = "Success")
        return dict(error = "not deleted")

    @view_config(route_name="image_browse",renderer="json")
    def browseimage(self):

        from os import listdir
        from os.path import isfile, join, splitext
        onlyfiles = self.request.storage.key_list(str(self.request.user.id))
        print onlyfiles

        if onlyfiles:
            response = [{"url":'%s'%(self.request.storage.url(f)),"thumb":'%s'%(self.request.storage.url(f))} for f in onlyfiles]
            return response
        return None

    @view_config(route_name="image_manager_delete",renderer="json")
    def imageManagerdelete(self):
        url = self.request.POST["src"]
        url = str(self.request.user.id)+'/'+url.split('/')[-1]
        filedeleted = self.request.storage.delete(url)
        if filedeleted:
            return dict(success = "Success")
        return dict(error = "not deleted")
'''
        form=Form(self.request, schema=BlogPost)
        if "form_submitted" in self.request.POST and form.validate():
            if not form.data['category_id'] or (len(form.data['category_id'])>8):
                self.session.flash('warning; You must select a category and your category selection should not be more than 8')
                return HTTPFound(location=self.request.route_url('add_blog'))
            blog=form.bind(Blogs(user=self.request.user,name = urlify_name(form.data['title'])),exclude=['category_id'],)
            for category in form.data['category_id']:
                t = DBSession.query(BlogCategory).get(category)
                blog.categories.append(t)
            dbsession.add(blog)

            dbsession.flush()

            return HTTPFound(location=self.request.route_url('blog_view',
                                                                    name=blog.name))
'''

"""

    @view_config(route_name="add_comment",request_method="POST", permission="post")
    def add_comments(self):
        if not self.request.user.email_verified:
            return HTTPFound(location=self.request.route_url('confirm_mail_holder'))
        form = Form(self.request,schema=CommentPost)
        if 'form_submitted' in self.request.POST and form.validate():
            comment = form.bind(Comments())
            comment.user = self.request.user

            with transaction.manager:
                DBSession.add(comment)
                DBSession.flush()
                if comment.user!=comment.blog.user:
                    message = Messages(
                        type = 'Comment',
                        url = self.request.route_url('blog_view',name=comment.blog.name)+"#comments",
                        title = comment.blog.title,
                        body = comment.blog.excerpt,
                        user_id = comment.blog.user.id
                    )
                    DBSession.add(message)
                    DBSession.flush()
                return HTTPFound(location = self.request.route_url('blog_view',
                                                                   name=comment.blog.name)+"#comments")

    @view_config(route_name="reply_comment",request_method="POST", permission="post")
    def reply_comments(self):
        if not self.request.user.email_verified:
            return HTTPFound(location=self.request.route_url('confirm_mail_holder'))
        comment_id = self.request.matchdict['comment_id']
        blog_name = self.request.matchdict['blog_name']
        comment = Comments.get_by_id(comment_id)
        form = Form(self.request,schema=CommentPost)
        if 'form_submitted' in self.request.POST and form.validate():
            comment2 = Comments(
                parent_id = comment.id,
                user_id = self.request.user.id,
                body= form.data['body']

            )
            with transaction.manager:
                DBSession.add(comment2)
                DBSession.flush()
                '''
                if comment2.user!=comment2.parent.user:
                    message = Messages(
                        type = 'reply',
                        url = self.request.route_url('blog_view',name=comment.blog.name)+"#comments",
                        title = comment.blog.title,
                        body = comment.excerpt,
                        user_id = comment.blog.user.id
                    )
                    DBSession.add(message)
                    DBSession.flush()
                    '''
                return HTTPFound(location = self.request.route_url('blog_view',
                                                                   name=blog_name)+"#comments")

    @view_config(route_name="edit_comment", renderer="buddy:templates/blog/edit_comment.mako")
    def edit_comments(self):

        comment = Comments.get_by_id(self.request.matchdict['comment_id'])
        if not comment:
            self.request.session.flash("danger; comment not found")
            return
        title = "Editing comment on "+comment.blog.title
        form = Form(self.request, schema=CommentPost, obj=comment)
        if "form_submitted" in self.request.POST and form.validate():
            form.bind(comment)
            DBSession.add(comment)
            DBSession.flush()
            return HTTPFound(location = self.request.route_url('blog_view',
                                                                   name=comment.blog.name)+"#comments")
        return dict(comment=comment, title=title, form=FormRenderer(form), blog_id=comment.blog.id)

    @view_config(route_name="delete_comment")
    def deletecomment(self):
        comment = Comments.get_by_id(self.request.matchdict['comment_id'])
        if not comment:
            self.request.session.flash("danger; comment not found")
            return
        DBSession.delete(comment)
        DBSession.flush()
        return HTTPFound(location = self.request.route_url('blog_view',
                                                                   name=comment.blog.name))


"""
