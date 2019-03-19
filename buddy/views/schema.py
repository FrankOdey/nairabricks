#!/usr/bin/env python
# -*- coding: utf-8 -*-
from formencode import validators, Schema, All, Invalid, ForEach, variabledecode
from buddy.models import DBSession
from buddy.models.user_model import Users

from pyramid.threadlocal import get_current_request

class Unique(validators.FancyValidator):
    'Validator to ensure that the value of a field is unique'

    def __init__(self, fieldName, errorMessage):
        'Store fieldName and errorMessage'
        super(Unique, self).__init__()
        self.fieldName = fieldName
        self.errorMessage = errorMessage

    def _to_python(self, value, user):
        'Check whether the value is unique'
        if DBSession.query(Users).filter(getattr(Users, self.fieldName)==value).first():
            raise Invalid(self.errorMessage, value, user)
        # Return
        return value


class Old_Password(validators.FancyValidator):
    'Validator to ensure that the old password match during change of password'

    def _to_python(self, value, user):
        'Check whether the value is unique'
        if not Users.check_password(email=get_current_request().authenticated_userid,
                                    password=value):
            raise Invalid('Your old password doesn\'t match', value, user)
        # Return
        return value


class Email_Exist(validators.FancyValidator):
    'Validator to ensure that the email exist in our database'

    def _to_python(self, value, user):
        'Check whether the value is unique'
        if Users.get_by_email(value) is None:
            raise Invalid('Sorry that email doesn\'t exist.', value, user)
        # Return
        return value


class SecurePassword(validators.FancyValidator):
    'Validator to prevent weak passwords'

    def _to_python(self, value, user):
        'Check whether a password is strong enough'
        if len(set(value)) < 6:
            raise Invalid('That password needs more variety', value, user)
        return value


class Registration(Schema):

    allow_extra_fields = True
    filter_extra_fields = True

    firstname = validators.UnicodeString(
            min=2,
            max=40,
            not_empty=True,
            strip=True)
    surname = validators.UnicodeString(min=2,max=40,not_empty=True,strip=True)
    is_pro = validators.Int(if_missing=0)
    user_type_id = validators.Int(if_missing=None)
    email = All(
        validators.UnicodeString(
            not_empty=True,
            strip=True),
        validators.Email(),
        Unique('email', u'That email is reserved for another account'))
    password = All(
        validators.UnicodeString(
            strip=True,
            not_empty=True,
            messages={'empty':u'Please enter a password'}
            ),
        SecurePassword())
    #confirm_password = validators.UnicodeString(not_empty=True,
     #                                           messages={'empty':u'Please confirm your password'},)

    #chained_validators = [validators.FieldsMatch(
    #    'password', 'confirm_password')]
    company_name = validators.UnicodeString(strip = True)
    #address = validators.UnicodeString(strip=True)
    #mobile = validators.UnicodeString(strip= True)
    #phone = validators.UnicodeString(strip=True)
    #state_id = validators.Int(if_empty=None)
    #city = validators.UnicodeString(strip=True)
    #note = validators.UnicodeString()

class UserRatingSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    rating = validators.Number(not_empty=True)
    review = validators.UnicodeString(not_empty=True)

class LoginForm(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    email = validators.Email(not_empty=True,strip=True)
    password = validators.UnicodeString(not_empty=True, strip=True)


class ChangePasswordForm(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    user_id = validators.Int()
    old_password = All(
        validators.UnicodeString(
            min=6,
            not_empty=True),
        Old_Password())
    password = validators.UnicodeString(not_empty=True)
    confirm_password = validators.UnicodeString(not_empty=True)
    chained_validators = [validators.FieldsMatch(
        'password', 'confirm_password')]


class ResetPasswordForm(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    password = All(
        validators.UnicodeString(
            min=6,
            not_empty=True),
        SecurePassword())

    confirm_password = validators.UnicodeString(not_empty=True)

    chained_validators = [validators.FieldsMatch(
        'password', 'confirm_password')]


class ForgotPasswordForm(Schema):
    allow_extra_fields = True
    filter_extra_fields = True


    email = All(
        validators.UnicodeString(
            not_empty=True,
            strip=True),
        validators.Email(),
        Email_Exist())

class ChangeEmailPassword(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    email = All(
        validators.UnicodeString(
            not_empty=True,
            strip=True
        ),
        validators.Email(),
        Unique('email', u'That email is reserved for another account.')
    )
    old_password = validators.UnicodeString(
            min=6,
            not_empty=True)
    confirm_password = validators.UnicodeString(not_empty=True)
    password = validators.UnicodeString(not_empty=True)
    chained_validators = [validators.FieldsMatch(
        'password', 'confirm_password')]

class NoteSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    note = validators.UnicodeString()


class WebVal(Schema):
    title = validators.UnicodeString()
    url = validators.UnicodeString()


class PersonalSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    pre_validators = [variabledecode.NestedVariables()]

    firstname = validators.UnicodeString(not_empty=True, strip=True)
    surname = validators.UnicodeString(not_empty=True, strip=True)
    headline = validators.UnicodeString(strip=True)
    company_name = validators.UnicodeString(strip = True)
    address = validators.UnicodeString(strip=True)
    mobile = validators.UnicodeString(strip= True)
    phone = validators.UnicodeString(strip=True)
    #websites = ForEach(WebVal())
    fb = validators.UnicodeString()
    tw = validators.UnicodeString()
    linkedin = validators.UnicodeString()
    user_type_id = validators.Int(not_empty=True)
    state_id = validators.Int(not_empty=True)
    city = validators.UnicodeString(not_empty=True, strip=True)
    prefix = validators.UnicodeString(required=True)

class AddGroup(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    name = validators.UnicodeString(not_empty=True)

class ContactSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    fullname = validators.UnicodeString(not_empty=True)
    mobile = validators.UnicodeString()
    email = validators.Email(not_empty=True)
    body = validators.UnicodeString(not_empty=True)

class PlanSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    name = validators.UnicodeString(not_empty=True, strip=True)
    price_per_month = validators.Number(not_empty=True,strip=True)
    max_listings = validators.Int(not_empty=True, strip=True)
    max_premium_listings = validators.Int(not_empty=True, strip=True)
    max_blogposts = validators.Int(not_empty=True, strip=True)
    max_premium_blogposts = validators.Int(not_empty=True, strip=True)
    featured_profile = validators.Bool(not_empty=True)


class PaymentSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    duration = validators.Int(not_empty=True)

class PromoSubSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    plan = validators.Int(not_empty=True)