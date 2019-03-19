#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.view import view_config
from buddy.models import DBSession
from buddy.models.properties_model import State, LGA, District
from pyramid.httpexceptions import HTTPFound
from buddy.views.dashboard.schema import StateSchema
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from sqlalchemy.exc import IntegrityError
import transaction
from webhelpers.paginate import PageURL_WebOb, Page

@view_config(route_name="add_lga",permission='admin', renderer="buddy:templates/dashboard/location/addlga.mako")
def addlga(request):
    title="Add Local Government Areas"
    state_id = request.matchdict['state_id']
    state = State.get_by_id(state_id)
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        lga_string = form.data['name']
        lga=LGA.create_lga(state_id,lga_string)
        request.session.flash("success; Lga added")
        return HTTPFound(location=request.route_url('view_state', state_id=state_id))
    action_url = request.route_url('add_lga', state_id=state_id)
    return dict(
        title=title,
        state=state,
        form=FormRenderer(form),
        action_url=action_url)

@view_config(route_name ="view_lga", permission='admin',renderer="buddy:templates/dashboard/location/viewlga.mako")
def viewlga(request):
    
    lga_id = request.matchdict['lga_id']
    lga = LGA.get_by_id(lga_id)
    title="Viewing %s" %(lga.name)
    return dict(
        title=title,
        lga=lga,
        state = lga.state
        )

@view_config(route_name="delete_lga",permission='admin',)
def delete_lga(request):
    dbsession=DBSession()
    lga_id = request.matchdict['lga_id']
    state_id = request.matchdict['state_id']
    lga = LGA.get_by_id(lga_id)
    if lga is None:
        request.session.flash('info; No such LGA')
        return HTTPFound(location = request.route_url("view_state",state_id=state_id))
    try:
        dbsession.delete(lga)
        request.session.flash('success; LGA deleted')
        return HTTPFound(location = request.route_url("view_state",state_id=state_id))
    except IntegrityError:
        transaction.abort()
        request.session.flash('info; operation failed')
        return HTTPFound(location = request.route_url("view_state",state_id=state_id))

@view_config(route_name ="edit_lga",permission='admin', renderer="buddy:templates/dashboard/location/editlga.mako")
def editlga(request):
    lga_id = request.matchdict['lga_id']
    state_id = request.matchdict['state_id']
    state=State.get_by_id(state_id)
    lga =LGA.get_by_id(lga_id)
    title = "Editing %s" %(lga.name)
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        s_string = form.data['name']
        lga.name = s_string
        lga.state_id = state_id
        DBSession.flush()
        request.session.flash("success; LGA updated")
        return HTTPFound(location=request.route_url('view_state', state_id=state_id))
    action_url = request.route_url('edit_lga',lga_id=lga_id, state_id=state_id)
    return dict(
        title=title,
        state=state,
        form=FormRenderer(form),
        lga=lga,
        action_url=action_url)

@view_config(route_name="add_district", permission='admin',renderer="buddy:templates/dashboard/location/adddistrict.mako")
def adddistrict(request):
    title="Add district to LGA"
    lga_id = request.matchdict['lga_id']
    lga = LGA.get_by_id(lga_id)
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        district_string = form.data['name']
        district=District.create_district(lga_id,district_string)
        request.session.flash("success; District(s) added")
        return HTTPFound(location=request.route_url('view_lga', lga_id=lga_id))
    action_url = request.route_url('add_district',lga_id=lga_id)
    return dict(
        title=title,
        lga=lga,
        form=FormRenderer(form),
        action_url=action_url)

@view_config(route_name ="edit_district",permission='admin', renderer="buddy:templates/dashboard/location/editdistrict.mako")
def editdistrict(request):
    district_id = request.matchdict['district_id']
    lga_id = request.matchdict['lga_id']
    lga = LGA.get_by_id(lga_id)
    district =District.get_by_id(district_id)
    title = "Editing %s" %(district.name)
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        s_string = form.data['name']
        district.name = s_string
        district.lga_id = lga_id
        DBSession.flush()
        request.session.flash("success; District updated")
        return HTTPFound(location=request.route_url('view_lga',lga_id=lga_id))
    action_url = request.route_url('edit_district',district_id=district_id,lga_id=lga_id)
    return dict(
        form=FormRenderer(form),
        district=district,
        lga=lga,
        title=title,
        action_url=action_url)


@view_config(route_name="delete_district",permission='admin')
def delete_district(request):
    dbsession=DBSession()
    district_id = request.matchdict['district_id']
    lga_id = request.matchdict['lga_id']
    district = District.get_by_id(district_id)
    if district is None:
        request.session.flash('info; No such area')
        return HTTPFound(location = request.route_url("view_district",lga_id=lga_id))
    try:
        dbsession.delete(district)
        DBSession.flush()
        request.session.flash('success; district deleted')
        return HTTPFound(location = request.route_url("view_lga",lga_id=lga_id))
    except IntegrityError:
        transaction.abort()
        request.session.flash('info; operation failed')
        return HTTPFound(location = request.route_url("view_lga",lga_id=lga_id))
    
@view_config(route_name ="view_state",permission='admin', renderer="buddy:templates/dashboard/location/viewstate.mako")
def viewstate(request):
    state_id = request.matchdict['state_id']
    state = State.get_by_id(state_id)
    title = "Viewing %s" %(state.name)
    lgas = DBSession.query(LGA).filter(LGA.state_id ==state_id).order_by(LGA.name).all()
    page_url = PageURL_WebOb(request)
    paginator = Page(lgas,
                     page=int(request.params.get("page", 1)), 
                     items_per_page=20, 
                     url=page_url)
    return dict(
        state=state,
        paginator = paginator,
        title=title
        )

@view_config(route_name ="add_state", permission='admin',renderer="buddy:templates/dashboard/location/addstate.mako")
def addstate(request):
    title = "Add State"
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        
        s_string = form.data['name']
        state=State.create_state(s_string)
        request.session.flash("success; State(s) added")
        return HTTPFound(location=request.route_url('list_state'))
    action_url = request.route_url('add_state')
    return dict(
        title=title,
        form=FormRenderer(form),
        action_url=action_url)

@view_config(route_name ="edit_state",permission='admin', renderer="buddy:templates/dashboard/location/editstate.mako")
def editstate(request):
    state_id = request.matchdict['state_id']
    state =State.get_by_id(state_id)
    title = "Editing %s" %(state.name)
    form = Form(request, schema=StateSchema)
    if 'form_submitted' in request.POST and form.validate():
        s_string = form.data['name']
        state.name = s_string
        transaction.commit()
        request.session.flash('success; State updated')
        return HTTPFound(location=request.route_url('list_state'))
    action_url = request.route_url('edit_state', state_id=state_id)
    return dict(
        title=title,
        form=FormRenderer(form),
        state=state,
        action_url=action_url)



@view_config(route_name ="list_state",permission='admin', renderer="buddy:templates/dashboard/location/states.mako")
def liststate(request):
    title = "State List"
    page = int(request.params.get('page', 1))
    paginator = State.get_paginator(request, page)
    total = DBSession.query(State).count()
    return dict(
        title=title,
        total=total,
        paginator=paginator,
        )

