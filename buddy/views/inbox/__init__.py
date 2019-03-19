#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'

def add_route(config):
    config.add_route('inbox','/user/{id}/inbox')
    config.add_route('view_message','/user/{id}/view')
    config.add_route('delete_message','/userinbox/{id}/delete/{user_id}')