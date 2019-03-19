#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'

from buddy.models.q_model import QCategory
from pyramid_simpleform import Form
from pyramid.view import view_config
from pyramid_simpleform.renderers import FormRenderer
from buddy.models import DBSession
import transaction
from buddy.views.dashboard.schema import BlogCategoryForm
from pyramid.httpexceptions import HTTPFound
from sqlalchemy.exc import IntegrityError




@view_config(route_name="add_q_category",
             renderer="buddy:templates/dashboard/q/new.mako")
def question_category_add(request):
    title='Add question category'
    form = Form(request, schema = BlogCategoryForm)
    if "form_submitted" in request.POST and form.validate():
        #add
        category = QCategory.create_category(form.data['name'])
        return HTTPFound(location=request.route_url("q_category_list"))

    action_url=request.route_url('add_q_category')
    return {'form':FormRenderer(form),'title':title,
            'action_url':action_url}

@view_config(route_name="q_category_list",
             renderer="buddy:templates/dashboard/q/list.mako")
def q_category_list(request):
    """question category list """
    title = 'List of question categories'
    page = int(request.params.get('page', 1))
    paginator = QCategory.get_paginator(request, page)
    return {'paginator':paginator, 'title':title}

@view_config(route_name="q_category_edit",
             renderer="buddy:templates/dashboard/q/edit.mako")
def q_category_edit(request):
    """q category edit """
    title = 'Edit q category'
    id= request.matchdict['id']
    dbsession = DBSession()
    category = QCategory.get_by_id(id)
    if category is None:
        request.session.flash("warning; Category not found!")
        return HTTPFound(location=request.route_url("q_category_list"))
    form = Form(request, schema=BlogCategoryForm, obj=category)
    if "form_submitted" in request.POST and form.validate():
        form.bind(category)
        dbsession.add(category)
        request.session.flash("success;The Category is saved!")
        return HTTPFound(location = request.route_url("q_category_list"))
    action_url = request.route_url("q_category_edit", id=id)
    return dict(form=FormRenderer(form),
                action_url=action_url)

@view_config(route_name="delete_q_category")
def delete_q_category(request):
    dbsession=DBSession()

    id = request.matchdict['id']
    category =QCategory.get_by_id(id)
    if category is None:
        request.session.flash('danger; No such category ')
        return HTTPFound(location = request.route_url("q_category_list"))
    try:
        transaction.begin()
        dbsession.delete(category);
        transaction.commit()
        request.session.flash('success; Category deleted')
        return HTTPFound(location=request.route_url("q_category_list"))
    except IntegrityError:
        transaction.abort()
        request.session.flash('danger; Unable to delete category')
        return HTTPFound(location=request.route_url("q_category_list"))
