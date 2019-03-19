#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.config import Configurator
from sqlalchemy import engine_from_config
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from buddy.utils.subscribers import add_renderer_globals,csrf_validation
import binascii
from pyramid_nacl_session import EncryptedCookieSessionFactory
from pyramid.events import BeforeRender, NewRequest
from buddy.models import Base, DBSession
from buddy.models.user_model import groupfinder,get_user
from buddy.models.resources import RootFactory
import time
from pyramid.static import QueryStringConstantCacheBuster

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    authn_policy = AuthTktAuthenticationPolicy(settings['buddy.site_secret'],
                                               callback=groupfinder,hashalg='sha512',max_age=864000, timeout=3600,reissue_time=120)
    authz_policy = ACLAuthorizationPolicy()
    hex_secret = settings['buddy.session_secret'].strip()
    secret = binascii.unhexlify(hex_secret)
    session_factory = EncryptedCookieSessionFactory(secret)
    config = Configurator(settings=settings,
                          authentication_policy=authn_policy,
                          authorization_policy=authz_policy,
                          session_factory=session_factory)

    cache = RootFactory.__acl__
    config.set_root_factory(RootFactory)
    config.add_request_method(get_user, 'user', reify=True)
    config.add_subscriber(add_renderer_globals, BeforeRender)
    config.set_default_csrf_options(require_csrf=True)
    config.add_static_view('static', 'static',cache_max_age=5184000)
    config.add_cache_buster(
        'buddy:static/',
        QueryStringConstantCacheBuster(str(int(time.time()))))
    config.add_static_view('deform_static', 'deform_bootstrap:static',cache_max_age=5184000)
    config.add_cache_buster(
        'buddy:deform_bootstrap/static/',
        QueryStringConstantCacheBuster(str(int(time.time()))))
    config.add_static_view('images','buddy:images')
    config.add_cache_buster(
        'buddy:images/',
        QueryStringConstantCacheBuster(str(int(time.time()))))
    config.include('pyramid_mailer')
    config.include("pyramid_mako")
    config.include("pyramid_retry")
    config.include('buddy.views.noprefix_include')
    config.include('buddy.views.profile_include')
    config.include('buddy.views.advice.noprefix_route')
    config.include('buddy.views.listing.noprefix_route')
    config.include('buddy.views.users_include',route_prefix='users')
    config.include('buddy.views.listing.add_route',route_prefix='listings')
    config.include('buddy.views.listing.add_route_listing_ajax',route_prefix="listings-ajax")
    config.include('buddy.views.dashboard.add_route',route_prefix='dashboard')
    config.include('buddy.views.advice.blog_route',route_prefix='blogs')
    config.include('buddy.views.inbox.add_route', route_prefix='message')
    config.include('buddy.views.document.add_route',route_prefix='corp')
    config.include("buddy.views.search.add_route", route_prefix="prosearch")
    config.include("buddy.views.pricing.pricing")
    config.include("buddy.pyramid_storage.s3")

    config.scan()
    return config.make_wsgi_app()
