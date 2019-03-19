#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'

from pyramid.view import view_config
from buddy.models import DBSession
from buddy.models.properties_model import Listings
from webhelpers.paginate import PageURL_WebOb, Page
class Dash(object):
    def __init__(self,request):
        self.request = request
        self.session = request.session
    @view_config(route_name='dashboard', renderer='buddy:templates/dashboard/index.mako')
    def dash(self):
        title = 'dashboard'

        return dict(title=title)

    @view_config(route_name='admin_search_listing',permission='superadmin',
             renderer='buddy:templates/dashboard/listing/disapproved.mako')
    def adminlistsearch(self):

        title = 'Unapproved Listings'

        listings = DBSession.query(Listings).filter(Listings.approved==False).filter(Listings.declined==False).all()
        page_url = PageURL_WebOb(self.request)
        paginator = Page(listings,
                         page=int(self.request.params.get("page", 1)),
                         items_per_page=5,
                         url=page_url)

        return dict(
            paginator=paginator,
            title=title
            )






