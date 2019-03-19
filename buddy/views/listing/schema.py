#!/usr/bin/env python
# -*- coding: utf-8 -*-
from formencode import validators, Schema, All, Invalid
import formencode
from formencode.foreach import ForEach

class PriceValidator(validators.FancyValidator):
    'Validator to ensure that the value of a field is unique'

    def _to_python(self, value, user):
        'return the value as integer'
        #value =str(value[2:])
        value = ''.join([i for i in value if i.isdigit()])
        # Return
        return int(value)

class NewListingSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    listing_type  = validators.UnicodeString(not_empty=True)
    title = validators.UnicodeString(not_empty=True,strip=True,messages={'empty':"Please enter a title that best describes your property"}, max=100)
    category_id = validators.Int(not_empty=True,
                                             messages={'empty':"Please categorize your property"})
    #subcategory_id = validators.Int(not_empty=True,
    #                            messages={'empty':"Choose a subcategory for your property"})
    state_id = validators.Int(not_empty=True,
                                             messages={'empty':"Please choose a state"})
    lga_id = validators.Int(not_empty=True,
                                             messages={'empty':"Please choose a region"})
    area = validators.UnicodeString(max=20,not_empty=True,strip=True,)
    address = validators.UnicodeString(not_empty=True,strip=True,
                                messages={'empty':"Please enter the property address"},max=100)
    show_address = validators.Int(if_missing=0)
    price = All(
        PriceValidator(),
        validators.UnicodeString(not_empty=True,
                                 messages={'empty': "Please enter the property price"})
    )
    price_available = validators.Int(if_missing=0)
    transaction_type = validators.UnicodeString()
    price_condition = validators.UnicodeString(max=100)
    deposit = validators.UnicodeString(strip=True)
    agent_commission = validators.UnicodeString(strip=True)
    available_from = validators.UnicodeString(strip=True)
    body = validators.UnicodeString(not_empty=True, strip=True,
                                    messages={"empty": "Please enter a description of your property"})
    area_size = validators.Int(not_empty=True, strip=True,
                               messages={"empty": "Please enter the land size of your property"})


class House(NewListingSchema):
    covered_area = validators.Int()
    bedroom = validators.Int(not_epmty=True, strip=True,
                             messages={'empty': 'Please enter the number of bedrooms in your property'})
    bathroom = validators.Int(not_epmty=True, strip=True,
                              messages={'empty': 'Please enter the number of bathrooms in your property'})
    total_room = validators.Int()
    year_built = validators.Int()
    furnished = validators.Int(if_missing=0)
    serviced = validators.Int(if_missing=0)
    #features = ForEach(validators.Int(if_missing=0))
    floor_no = validators.Int(not_epmty=True, strip=True,
                              messages={'empty': 'Please enter the floor number of this property'})
    total_floor = validators.Int(not_epmty=True, strip=True,
                                 messages={'empty': 'Please enter the total floor in this property'})
    car_spaces = validators.Int(strip=True)



class Propertyedit(Schema):
    allow_extra_fields = True
    filter_extra_fields = True
    listing_type = validators.UnicodeString(not_empty=True)
    title = validators.UnicodeString(not_empty=True, strip=True,
                                     messages={'empty': "Please enter a title that best describes your property"},
                                     max=100)

    subcategory_id = validators.Int(not_empty=True,
                               messages={'empty':"Choose a subcategory for your property"})
    state_id = validators.Int(not_empty=True,
                              messages={'empty': "Please choose a state"})
    lga_id = validators.Int(not_empty=True,
                            messages={'empty': "Please choose a region"})
    dist = validators.UnicodeString(max=20, not_empty=True, strip=True, )
    address = validators.UnicodeString(not_empty=True, strip=True,
                                       messages={'empty': "Please enter the property address"}, max=100)
    show_address = validators.Int(if_missing=0)
    price = All(
        PriceValidator(),
        validators.UnicodeString(not_empty=True,
                                 messages={'empty': "Please enter the property price"})
    )
    price_available = validators.Int(if_missing=0)
    transaction_type = validators.UnicodeString()
    price_condition = validators.UnicodeString(max=100)
    deposit = validators.UnicodeString(strip=True)
    agent_commission = validators.UnicodeString(strip=True)
    available_from = validators.UnicodeString(strip=True)
    body = validators.UnicodeString(not_empty=True, strip=True,
                                    messages={"empty": "Please enter a description of your property"})
    area_size = validators.Int(not_empty=True, strip=True,
                               messages={"empty": "Please enter the land size of your property"})


class HouseEdit(Propertyedit):
    covered_area = validators.Int()
    bedroom = validators.Int(not_epmty=True, strip=True,
                             messages={'empty': 'Please enter the number of bedrooms in your property'})
    bathroom = validators.Int(not_epmty=True, strip=True,
                              messages={'empty': 'Please enter the number of bathrooms in your property'})
    total_room = validators.Int()
    year_built = validators.Int()
    furnished = validators.Int(if_missing=0)
    serviced = validators.Int(if_missing=0)
    #features = ForEach(validators.Int(if_missing=0))
    floor_no = validators.Int(not_epmty=True, strip=True,
                              messages={'empty': 'Please enter the floor number of this property'})
    total_floor = validators.Int(not_epmty=True, strip=True,
                                 messages={'empty': 'Please enter the total floor in this property'})
    car_spaces = validators.Int(strip=True)


class FeaturesSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    featuresd = validators.Int()


class ListingUpload(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    file = validators.String(not_empty=True)


class MailAgentSchema(Schema):
    filter_extra_fields = True
    allow_extra_fields = True
    fullname = validators.UnicodeString(strip=True,not_empty=True)
    mobile = validators.UnicodeString(strip=True)
    email = validators.Email(strip=True,not_empty=True)
