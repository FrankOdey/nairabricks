#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'


def add_route(config):
    config.add_route('about','/about')
    config.add_route('contact','contact-us')
    config.add_route('terms','/terms')
    config.add_route('privacy','/privacy')
    config.add_route("goodneighbor",'/good-neighbor-policy')
    config.add_route("listing_quality","/listing-quality-policy")