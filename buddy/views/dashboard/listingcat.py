#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'

from buddy.models.properties_model import PropertyCategory, Listings,Photos
from pyramid_simpleform import Form
from pyramid.view import view_config
from pyramid_simpleform.renderers import FormRenderer
from buddy.models import DBSession
import transaction
from buddy.views.dashboard.schema import BlogCategoryForm
from pyramid.httpexceptions import HTTPFound
from sqlalchemy.exc import IntegrityError
import os



@view_config(route_name="add_listing_category",
             renderer="buddy:templates/dashboard/listing/new.mako")
def listing_category_add(request):
    title='Add listing category'
    form = Form(request, schema = BlogCategoryForm)
    if "form_submitted" in request.POST and form.validate():
        #add
        category = PropertyCategory.create_category(form.data['name'])
        return HTTPFound(location=request.route_url("listing_category_list"))

    action_url=request.route_url('add_listing_category')
    return {'form':FormRenderer(form),'title':title,
            'action_url':action_url}

@view_config(route_name="listing_category_list",
             renderer="buddy:templates/dashboard/listing/list.mako")
def listing_category_list(request):
    """listing category list """
    title = 'List of property categories'
    page = int(request.params.get('page', 1))
    paginator = PropertyCategory.get_paginator(request, page)
    listings = DBSession.query(Listings).join(Photos).all()
    #a = []
    #for lis in listings:
    #    if len(lis.pictures.all())>0:
     #       for p in lis.pictures.all():
                #fname = os.path.splitext(p.filename)[0]
                #p.thumbnail = fname +'_t.jpg'
          #      a.append(p.filename)
    return {'paginator':paginator, 'title':title}

@view_config(route_name="listing_category_edit",
             renderer="buddy:templates/dashboard/listing/edit.mako")
def listing_category_edit(request):
    """listing category edit """
    title = 'Edit listing category'
    id= request.matchdict['id']
    dbsession = DBSession()
    category = PropertyCategory.get_by_id(id)
    if category is None:
        request.session.flash("warning; Category not found!")
        return HTTPFound(location=request.route_url("listing_category_list"))
    form = Form(request, schema=BlogCategoryForm, obj=category)
    if "form_submitted" in request.POST and form.validate():
        form.bind(category)
        dbsession.add(category)
        request.session.flash("success;The Category is saved!")
        return HTTPFound(location = request.route_url("listing_category_list"))
    action_url = request.route_url("listing_category_edit", id=id)
    return dict(form=FormRenderer(form),
                action_url=action_url)

@view_config(route_name="delete_listing_category")
def delete_listing_category(request):
    dbsession=DBSession()

    id = request.matchdict['id']
    category = PropertyCategory.get_by_id(id)
    if category is None:
        request.session.flash('danger; No such category ')
        return HTTPFound(location = request.route_url("listing_category_list"))
    try:
        transaction.begin()
        dbsession.delete(category);
        transaction.commit()
        request.session.flash('success; Category deleted')
        return HTTPFound(location=request.route_url("listing_category_list"))
    except IntegrityError:
        transaction.abort()
        request.session.flash('danger; Unable to delete category')
        return HTTPFound(location=request.route_url("listing_category_list"))
