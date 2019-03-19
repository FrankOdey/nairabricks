#!/usr/bin/env python
# -*- coding: utf-8 -*-
from buddy.models.user_model import UserFactory
from buddy.models.resources import RootFactory

def noprefix_include(config):
    config.add_route('search','/searchitems', factory=RootFactory)
    config.add_route('search-users','/users')
    config.add_route('reg','/registration', factory=UserFactory)
    config.add_route('login','/login')
    config.add_route('logout','/logout', factory=UserFactory)
    config.add_route('account','/myaccount', factory=UserFactory)
    config.add_route('account-listings','/mylistings', factory=UserFactory)
    config.add_route('account-blogs','/myblogs', factory = UserFactory)
    config.add_route('account-referrals','/myreferrals')
    config.add_route('email_pass', '/emailpasswordedit', factory=UserFactory)
    config.add_route('check_oldpassword', 'account/check-oldpassword')
    config.add_route('check_email', 'account/check-email')


def profile_include(config):
    config.add_route('home','/', factory=RootFactory)
    config.add_route('profile','/profile/{prefix}',traverse="/{prefix}", factory=UserFactory)

def users_include(config):
    config.add_route('user_picture_upload','/upload/{prefix}', traverse='/{prefix}', factory=UserFactory)
    config.add_route('user_edit','/settings', factory=UserFactory)
    config.add_route('company_pix_upload','/company/upload/{prefix}', traverse='/{prefix}', factory=UserFactory)
    config.add_route('cover_pix_upload','/cover/upload/{prefix}', traverse='/{prefix}', factory=UserFactory)
    config.add_route('change_password','/changepassword', factory=UserFactory)
    config.add_route('forgot_password','/passforgot', factory=UserFactory)
    config.add_route('email_activate','/activate/:user_id/:hmac')
    config.add_route('reset_password','/reset/:user_id/:hmac')
    config.add_route('send_confirmation_email','/send_email_confirmation')
    config.add_route('confirm_mail_holder','/confirmation_email')
    config.add_route('personal-update','/update-personal')
    config.add_route('about-update', '/update-about')
    config.add_route('add_group','/add_group')
    config.add_route('user_log', '/user_log')
    config.add_route('user_list','/user_list')
    config.add_route('add_to_favourites','/save_favourites')
    config.add_route('remove_favourites','/remove_favourites')
    config.add_route('search_user_list','/search')
    config.add_route('make_admin','/{id}/{pos}/make_admin')
    config.add_route('deny_admin','/{id}/deny/{pos}')
    config.add_route('user_blog','/{prefix}/blogs', factory=UserFactory, traverse='/{prefix}')
    config.add_route('user_blog_filter','/{prefix}/blogs/filter/{category}')
    config.add_route('user_questions','/{prefix}/questions', factory=UserFactory, traverse='/{prefix}')
    config.add_route('user_answers','/{prefix}/answers', factory=UserFactory, traverse='/{prefix}')
    config.add_route('user_question_filter','/{prefix}/questions/filter/{category}')
    config.add_route('user_listings','/{prefix}/listings')
    config.add_route('verify_user','/{prefix}/verify')
    config.add_route('deny_verified','/{prefix}/denyverifed')
    config.add_route('user_rating','/{prefix}/rating')
    config.add_route('user_ratings_and_reviews','/{prefix}/ratingsandreview')
    config.add_route('contact_user','/{prefix}/contact')
    config.add_route('favourite_properties','/{prefix}/savedproperties')
    config.add_route('delete_user','/{prefix}/delete')


