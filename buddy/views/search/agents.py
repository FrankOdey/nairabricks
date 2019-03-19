#!/usr/bin/env python
# -*- coding: utf-8 -*-
from buddy.models import DBSession
from buddy.models.properties_model import State
from buddy.models.user_model import User_types, Users
from webhelpers.paginate import PageURL_WebOb, Page
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
from pyramid.renderers import render_to_response
from sqlalchemy import or_,func, and_
import json
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer

__author__ = 'ephraim'

class ProSearch(object):
    def __init__(self, request):
        self.request = request
        self.session = request.session

    @view_config(route_name="find_pros", renderer="buddy:templates/search/index.mako")
    def index(self):
        form = Form(self.request)
        params = self.request.params
        protype = params.get('type','')
        location = params.get('cities_auto','')
        name = params.get('name','')
        users = DBSession.query(Users)
        if protype:
            users = users.join(User_types).filter(User_types.id==protype)
        if location and name:
            st = State.get_by_name(location)
            name="%"+name+"%"
            filters = or_(Users.fullname.like(name),Users.company_name.like(name))
            users = users.filter(Users.state_id==st.id).filter(filters)
        if location and not name:
            st = State.get_by_name(location)
            users = users.filter(Users.state==st)
        if name and not location:
            namelike="%"+name+"%"
            filters = or_(Users.fullname.like(namelike),Users.company_name.like(namelike))
            users = users.filter(filters)
        users = users.filter(and_(Users.email!=u'info@nairabricks.com',Users.email!=u'splendidzigy24@gmail.com')).order_by((Users.photo!=None).desc()).all()
        page_url = PageURL_WebOb(self.request)
        paginator = Page(users,
                     page=int(self.request.params.get("page", 1)),
                     items_per_page=12,
                     url=page_url)

        return dict(title="Nairabricks Real Estate Professionals",
                    name = name,
                    location = location,
                    protype= protype,
                    form = FormRenderer(form),paginator=paginator)





