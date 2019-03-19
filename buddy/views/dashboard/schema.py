#!/usr/bin/env python
# -*- coding: utf-8 -*-
from formencode import validators, Schema


class TagForm(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    
    name = validators.UnicodeString(not_empty=True)


class BlogCategoryForm(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    parent = validators.Int(if_empty=None)
    name = validators.UnicodeString(not_empty=True)
    description = validators.UnicodeString()
    
class FrontPixUpload(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    pics = validators.String(not_empty=True)

class StateSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    name = validators.UnicodeString(not_empty=True)