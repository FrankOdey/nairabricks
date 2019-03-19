#!/usr/bin/env python
# -*- coding: utf-8 -*-
def add_route(config):
    config.add_route('admin_search_listing','/search_listings')
    #config.add_route('add_tag','/tag/add')
    #config.add_route('tag_list','/tag/list')
    #config.add_route('tag_edit','/tag/{tag_id}/edit')
    #config.add_route('delete_tag','/tag/{tag_id}/delete')
    #blog category routes
    config.add_route('add_blog_category','/blog/category/add')
    config.add_route('blog_category_list','/blog/category/list')
    config.add_route('blog_category_edit','/blog/categories/{id}/edit')
    config.add_route('delete_blog_category','/blog/category/{id}/delete')
    config.add_route('add_frontpage_picture','/frontpageo/addpix')
    config.add_route("delete_frontpage_upload",'frontpages/{id}/delete')
    config.add_route('frontpage_upload','/frontpage/upload')
    config.add_route('dashboard','/index')

    #listing category routes
    config.add_route('add_listing_category','/dashboard/listing/category/add')
    config.add_route('listing_category_list','/dashboard/listing/category/list')
    config.add_route('listing_category_edit','/dashboard/listing/category/{id}/edit')
    config.add_route('delete_listing_category','/dashboard/listing/category/{id}/delete')

    #question category routes
    config.add_route('add_q_category','/dashboard/question/category/add')
    config.add_route('q_category_list','/dashboard/question/category/list')
    config.add_route('q_category_edit','/dashboard/question/category/{id}/edit')
    config.add_route('delete_q_category','/dashboard/question/category/{id}/delete')

    #city
    config.add_route('add_lga','/dashboard/lga/{state_id}/add')
    config.add_route('view_lga','/dashboard/{lga_id}/lga/view')
    config.add_route('delete_lga','/dashboard/{lga_id}/{state_id}/lga/delete')
    config.add_route('edit_lga','/dashboard/{lga_id}/{state_id}/lga/edit')

    #area
    config.add_route('add_district','/dashboard/{lga_id}/district/add')
    config.add_route('edit_district','/dashboard/{district_id}/{lga_id}/district/edit')
    config.add_route('delete_district','/dashboard/{district_id}/{lga_id}/district/delete')
    #state
    config.add_route('view_state','/dashboard/{state_id}/state/view')
    config.add_route('add_state','/dashboard/state/add')
    config.add_route('edit_state','/dashboard/{state_id}/state/edit')
    config.add_route('delete_state','/dashboard/{state_id}/state/delete')
    config.add_route('list_state','/dashboard/state/list')
