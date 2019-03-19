#!/usr/bin/env python
# -*- coding: utf-8 -*-
from formencode import validators, Schema, All, Invalid
from formencode.foreach import ForEach


class BlogPost(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    
    title = validators.UnicodeString(
        max = 255,
        min=2,
        not_empty = True,
        messages = {'empty':u'Please enter a title for your blog post'}
        )
    body = validators.UnicodeString(
        min=5,
        not_empty=True,
        messages={'empty':u'Enter your blog post'}
        )
    category_id = ForEach(validators.Int())
    #state_id = validators.Int()
    #city = validators.UnicodeString(max=50)


class QuestionPost(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    
    title = validators.UnicodeString(
        max = 255,
        min=2,
        not_empty = True,
        messages = {'empty':u'Please ask your question'}
        )
    body = validators.UnicodeString()
    category_id = ForEach(validators.Int())
    state_id = validators.Int()
    city = validators.UnicodeString(max=50)
    anonymous = validators.Int(if_missing=0)
    
class AnswerPost(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    
    q_id = validators.Int()
    body  = validators.UnicodeString( 
        not_empty=True,
        min=3,
        messages={'empty':u'Please answer the question before submitting'}
        )
    anonymous = validators.Int(if_missing=0)

class CommentPost(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    
    blog_id = validators.Int(not_empty=True)
    body = validators.UnicodeString(not_empty=True,
                                    messages={'empty':'Please comment before submitting'}
                                    )
