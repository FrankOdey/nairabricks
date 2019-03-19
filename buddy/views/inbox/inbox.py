#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.httpexceptions import HTTPFound
from buddy.models.user_model import Users, Messages
from buddy.models import DBSession
from pyramid.view import view_config
from webhelpers.paginate import PageURL_WebOb, Page

__author__ = 'ephraim'




class InboxView(object):

    def __init__(self, request):
        self.request = request
        self.session = request.session

    @view_config(route_name="inbox", renderer="buddy:templates/messages/inbox.mako")
    def inbox(self):
        id = self.request.matchdict['id']
        user = Users.get_by_id(id)
        if not user:
            self.session.flash('info; No such user')
            return HTTPFound(location = self.request.route_url('home'))
        messages = DBSession.query(Messages).filter(Messages.user_id==user.id).order_by(Messages.created.desc()).all()
        page_url = PageURL_WebOb(self.request)
        paginator = Page(messages,
                     page=int(self.request.params.get("page", 1)),
                     url=page_url)
        for message in messages:
            message.is_seen = True
        DBSession.flush()
        return dict(user=user, paginator=paginator, mess='mess')
    @view_config(route_name="view_message",renderer="buddy:templates/messages/viewmessage.mako")
    def view(self):
        id = self.request.matchdict['id']
        message = Messages.get_by_id(id)
        if not message:
            self.session.flash('info; No such message')
            return HTTPFound(location=self.request.route_url('home'))
        message.is_read=True
        DBSession.flush()
        return dict(message=message,mess='mess')
    @view_config(route_name="delete_message")
    def delete_m(self):
        id = self.request.matchdict['id']
        user_id = self.request.matchdict['user_id']

        message = Messages.get_by_id(id)
        if not message:
            self.session.flash('info; No such message')
            return HTTPFound(location=self.request.route_url('home'))
        DBSession.delete(message)
        DBSession.flush()
        return HTTPFound(location=self.request.route_url('inbox',id=user_id))