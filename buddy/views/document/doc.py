#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
from formencode import validators, Schema
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.views.messages import html_email_sender
@view_config(route_name="about", renderer="buddy:templates/document/about.mako")
def about(request):
    return dict(title="About Us", )

@view_config(route_name="terms", renderer="buddy:templates/document/terms.mako")
def terms(request):
    return dict(title="Terms of use")

@view_config(route_name="privacy", renderer="buddy:templates/document/privacy.mako")
def privacy(request):

    return dict(title="Privacy")

@view_config(route_name="goodneighbor", renderer="buddy:templates/document/goodneighbor.mako")
def goodneighbor(request):
    return dict(title="Good Neighbor Policy")

@view_config(route_name="listing_quality", renderer="buddy:templates/document/listing_quality.mako")
def quality(request):
    return dict(title="Listing Quality Policy")

class ContactUs(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    fullname = validators.UnicodeString(not_empty=True)
    email = validators.Email(not_empty=True)
    body = validators.UnicodeString(not_empty=True)

@view_config(route_name="contact", renderer="buddy:templates/document/contact.mako")
def contact(request):
    form=Form(request, schema=ContactUs)
    if 'submit' in request.POST and form.validate():
        name = form.data['fullname']
        email = form.data['email']
        body = form.data['body']
        subject = "Contact Request by %s"%name
        extra_headers={
            "Reply-To": '%s <%s>'%(name, email)
        }
        html_email_sender(request,
                             recipients="info@nairabricks.com",
                             subject = subject,
                             body=body,
                             extra_headers=extra_headers,
                             sender="no-reply@nairabricks.com",
            )
        request.session.flash('info;Email sent, thank you for contacting us')
        return HTTPFound(location="/")
    return dict(title="contact us", form = FormRenderer(form))