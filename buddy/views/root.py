#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.view import view_config,notfound_view_config
from pyramid.renderers import render_to_response
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from pyramid.response import Response
from buddy.models import *
from buddy.models.blogs_model import Blogs
from buddy.models.resources import Content, Featured_Content, FrontPix
from sqlalchemy import or_, asc, and_,desc
from webhelpers.paginate import PageURL_WebOb, Page
from buddy.models.user_model import Users
from buddy.models.q_model import Questions
from buddy.models.properties_model import Listings, State, PropertyCategory
import random
import time

class HomeView(object):
    
    def __init__(self, request):
        self.request = request

    @view_config(route_name="home",renderer="buddy:templates/home/home.mako")
    def root(self):

        form = Form(self.request)
        premium = DBSession.query(Featured_Content).filter(Featured_Content.name==u"Premium").first()
        if premium:
          premium = premium.featured_properties
        listings = DBSession.query(Listings).filter(Listings.approved==True).order_by(Listings.created.desc()).\
            filter(Listings.status==True).limit(8).all()
        #blogs = DBSession.query(Blogs).filter(Blogs.status==True).order_by(desc(Blogs.created)).limit(12).all()
        stoc_pics = DBSession.query(FrontPix).all()
        background_pic = None
        if stoc_pics:
            background_pic= random.choice([i.filename for i in stoc_pics])
        states = State.all()
        property_categories = DBSession.query(PropertyCategory).all()
        self.request.response.cache_control.prevent_auto = True
        reflink = self.request.params.get('refid', None)
        if reflink:
            user = DBSession.query(Users).filter(Users.serial == reflink).first()
            if user:
                session = self.request.session
                session['ref_email'] = user.email
                session.save()
                session.persist()
        return dict(title= "Nigeria Real Estate & Property Marketplace For Sale and Rent",
                    form=FormRenderer(form),listings=listings,premium=premium,
                    states=states,time=time.time(),
                   # blogs=blogs,
                    background_pic=background_pic,
                    property_categories=property_categories)

    @notfound_view_config(renderer="buddy:templates/home/notfound.mako")
    def notfound_bro(self):
        res = 'The page you are looking for could not be found. It might have been deleted. We apologise for any inconvenience.'
        return dict(res=res,title="Page Not Found")


@view_config(route_name="search",request_method="GET")
def search(request):
    """This searches contents i.e Blogs, Questions"""
    title = "Voices search"
    search_term = request.params.get('search_term','')
    form = Form(request)
    searchstring = u'%%%s%%' % search_term

    # generic_filter can be applied to all Node (and subclassed) objects

    generic_filter = or_(
                         Content.title.like(searchstring),
                         Content.body.like(searchstring),
                         )

    results = DBSession.query(Content).filter(Content.type !='listing').filter(generic_filter).\
            order_by(Content.title.asc()).all()


    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(results,
                     page=page,
                     items_per_page=10,
                     url=page_url)

    return render_to_response("buddy:templates/home/searchresult.mako",
                                  dict(paginator=paginator,title=title,
                                       form=FormRenderer(form)),request=request)

@view_config(route_name="search-users", request_method="GET")
def user_search(request):
    title = 'Professionals'
    search_term = request.params.get('search_term','')
    form = Form(request)
    searchstring = u'%%%s%%' %search_term

    generic_filter = or_(
        Users.firstname.like(searchstring),
        Users.surname.like(searchstring),
        Users.company_name.like(searchstring)
    )
    results = DBSession.query(Users).filter(generic_filter).\
        filter(and_(Users.email!=u'info@nairabricks.com',Users.email!=u'splendidzigy24@gmail.com'))\
        .order_by((Users.photo!=None).desc()).all()

    page_url = PageURL_WebOb(request)
    page = int(request.params.get("page", 1))
    paginator = Page(results,
                     page=page,
                     items_per_page=10,
                     url=page_url)

    return render_to_response("buddy:templates/search/index.mako",
                                  dict(paginator=paginator,
                                       title=title,
                                       name = search_term,
                                        location = '',
                                        protype= '',
                                       form=FormRenderer(form)),request=request)

