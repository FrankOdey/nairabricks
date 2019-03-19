#!/usr/bin/env python
# -*- coding: utf-8 -*-

from buddy.models.properties_model import ListingFactory

def noprefix_route(config):
    config.add_route('all_property_listing','/listings',factory=ListingFactory)
    config.add_route('mail_agents','/mailagent')

def add_route(config):
    #listing factory
    config.add_route('add_listings', '/addProperty', factory=ListingFactory)
    config.add_route('edit_listing','/editProperty/{name}', traverse="/{name}", factory=ListingFactory)
    config.add_route('for_sale', '/submit-for-sale', factory=ListingFactory)
    config.add_route('for_rent', '/submit-for-rent', factory=ListingFactory)
    config.add_route('listing_upload', '/fileuploads/{listing_id}/', factory=ListingFactory)
    config.add_route('delete_upload', '/delete-upload/{name}/{photo_id}', factory=ListingFactory, traverse="/{name}")
    config.add_route('step2', '/uploads/{name}', traverse="/{name}", factory=ListingFactory)
    config.add_route('buy','/buy',factory=ListingFactory)
    config.add_route('rent','/rentals',factory=ListingFactory)
    config.add_route('browse_state','/location/{state_name}')
    config.add_route('browse_region','/location/{state_name}/{region_id}/{region_name}')
    config.add_route('browse_area','/location/{state_name}/{region_name}/{area_id}/{area_name}')
    config.add_route('browse_category','/type/{category_id}/{category_name}')
    config.add_route('search_properties','/searchproperties')
    config.add_route('cities_autocomplete','/cities_autocomplete')
    config.add_route('property_view','/{name}',traverse="/{name}",factory=ListingFactory)
    config.add_route('delete_listing','/{id:\d+}/delete')
    config.add_route('for_sale_category','/{ptype}/for-sale')
    config.add_route('forsale_p_s_l','/{state}/{lga}/{ptype}/for-sale/*fizzle')
    config.add_route('forsale_p_s','/{state}/{ptype}/for-sale/*fizzle')

def add_route_listing_ajax(config):
    config.add_route('make_premium_listing', "/make-premium-listing")
    #config.add_route('remove_premium_listing','/remove-premium-listing')
    config.add_route('approve_listing',"/approve-listing")
    config.add_route('decline_listing',"/decline-listing")
    config.add_route("mark_as_sold","/markassold")
    config.add_route('get_lgas','/lgas-ajax',factory=ListingFactory)


    
 