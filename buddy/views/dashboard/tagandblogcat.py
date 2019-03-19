#!/usr/bin/env python
# -*- coding: utf-8 -*-

from pyramid_simpleform import Form
from pyramid.view import view_config
from pyramid_simpleform.renderers import FormRenderer
from buddy.models import DBSession
#from buddy.models.resources import Tags
from buddy.models.blogs_model import BlogCategory
import transaction
from buddy.views.dashboard.schema import TagForm, BlogCategoryForm
from pyramid.httpexceptions import HTTPFound
from sqlalchemy.exc import IntegrityError

'''@view_config(route_name="add_tag",
             renderer="buddy:templates/dashboard/tag/new.mako")
def tag(request):
    #add tag

    title= 'Add tag'
    form = Form(request, schema = TagForm)
    if "form_submitted" in request.POST and form.validate():
        #add
        tag = Tags.create_tags(form.data['name'])
        return HTTPFound(location=request.route_url("tag_list"))
    
    action_url=request.route_url('add_tag')
    return {'form':FormRenderer(form),'title':title,
            'action_url':action_url}

@view_config(route_name="tag_list",
             renderer="buddy:templates/dashboard/tag/tag_list.mako")
def tag_list(request):

    title='Tag list'
    page = int(request.params.get('page', 1))
    paginator = Tags.get_paginator(request, page)
    return {'paginator':paginator,'title':title}

@view_config(route_name="tag_edit", 
             renderer="buddy:templates/dashboard/tag/edit.mako")
def tag_edit(request):

    title='edit tag'
    tag_id= request.matchdict['tag_id']
    dbsession = DBSession()
    tag = Tags.get_by_id(tag_id)
    if tag is None:
        request.session.flash("warning; Tag not found!")
        return HTTPFound(location=request.route_url("tag_list"))        
    form = Form(request, schema=TagForm, obj=tag)    
    if "form_submitted" in request.POST and form.validate():
        form.bind(tag)
        dbsession.add(tag)
        request.session.flash("success;The Tag is saved!")
        return HTTPFound(location = request.route_url("tag_list"))
    action_url = request.route_url("tag_edit", tag_id=tag_id)
    return dict(form=FormRenderer(form),title=title,
                action_url=action_url)

@view_config(route_name="delete_tag")
def delete_tag(request):
    dbsession=DBSession()
    tag_id = request.matchdict['tag_id']
    tag = Tags.get_by_id(tag_id)
    if tag is None:
        request.session.flash('danger; No such tag found')
        return HTTPFound(location = request.route_url("tag_list"))
    try:
        transaction.begin()
        dbsession.delete(tag);
        transaction.commit()
        request.session.flash('success; Tag deleted')
        return HTTPFound(location=request.route_url("tag_list"))
    except IntegrityError:
        transaction.abort()
        request.session.flash('danger; Unable to delete tag')
        return HTTPFound(location=request.route_url("tag_list"))'''


@view_config(route_name="add_blog_category",
             renderer="buddy:templates/dashboard/blogcategory/new.mako")
def blog_category_add(request):
    title='Add blog category'
    parent_categories= DBSession.query(BlogCategory).filter(BlogCategory.parent==None).all()
    parent_categories = [(x.id,x.name) for x in parent_categories]
    form = Form(request, schema = BlogCategoryForm)
    if "form_submitted" in request.POST and form.validate():
        #add
        category = BlogCategory(name=form.data['name'],
                                description=form.data['description'],
                                parent = form.data['parent'])
        DBSession.add(category)
        DBSession.flush()
        request.session.flash('success; category saved')
        return HTTPFound(location=request.route_url("blog_category_list"))
    
    action_url=request.route_url('add_blog_category')
    return {'form':FormRenderer(form),'title':title,
            'action_url':action_url,'parent_categories':parent_categories}

@view_config(route_name="blog_category_list",
             renderer="buddy:templates/dashboard/blogcategory/list.mako")
def blog_category_list(request):

    title = 'List of blog categories'
    page = int(request.params.get('page', 1))
    paginator = BlogCategory.get_paginator(request, page)
    return {'paginator':paginator, 'title':title}

@view_config(route_name="blog_category_edit", 
             renderer="buddy:templates/dashboard/blogcategory/edit.mako")
def blog_category_edit(request):

    title = 'Edit blog category'
    id= request.matchdict['id']
    parent_categories= DBSession.query(BlogCategory).filter(BlogCategory.parent==None).all()
    parent_categories = [(x.id,x.name) for x in parent_categories]

    category = BlogCategory.get_by_id(id)
    if category is None:
        request.session.flash("warning; Category not found!")
        return HTTPFound(location=request.route_url("blog_category_list"))        
    form = Form(request, schema=BlogCategoryForm, obj=category)    
    if "form_submitted" in request.POST and form.validate():
        form.bind(category)
        DBSession.add(category)
        request.session.flash("success;The Category is saved!")
        return HTTPFound(location = request.route_url("blog_category_list"))
    action_url = request.route_url("blog_category_edit", id=id)
    return dict(form=FormRenderer(form),category=category, parent_categories=parent_categories,
                action_url=action_url)

@view_config(route_name="delete_blog_category")
def delete_blog_category(request):
    dbsession=DBSession()

    id = request.matchdict['id']
    category = BlogCategory.get_by_id(id)
    if category is None:
        request.session.flash('danger; No such category ')
        return HTTPFound(location = request.route_url("blog_category_list"))
    try:
        transaction.begin()
        dbsession.delete(category);
        transaction.commit()
        request.session.flash('success; Category deleted')
        return HTTPFound(location=request.route_url("blog_category_list"))
    except IntegrityError:
        transaction.abort()
        request.session.flash('danger; Unable to delete category')
        return HTTPFound(location=request.route_url("blog_category_list"))
