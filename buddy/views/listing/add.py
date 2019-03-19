#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.view import view_config
#from pyramid.decorator import reify
from pyramid.renderers import render_to_response, render
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from pyramid.httpexceptions import HTTPFound,HTTPSeeOther, HTTPNotFound
from buddy.utils.url_normalizer import urlify_name

from buddy.views.listing.schema import ListingUpload, NewListingSchema, House, Propertyedit, HouseEdit, FeaturesSchema
from buddy.models import *
from buddy.models.properties_model import (Listings,Property_extras,
                                           State,
                                           Feature_types,Features,
                                           PropertyCategory,
                                           Photos, LGA, District)
from sqlalchemy.sql import func
import os
from PIL import Image,ImageFile
from cStringIO import StringIO
from buddy.views.messages import non_html_email_sender


def optimize(image_file):
    img = Image.open(image_file).convert('RGB')
    ImageFile.MAXBLOCK = img.size[0] * img.size[1]
    size = (1200,630)
    output_img = StringIO()
    if img.size>size:
        img.thumbnail(size)
        if not img.mode == 'RGB':
            img.save(output_img,"PNG",optimize=True,quality=85)
        else:
            img.save(output_img, "JPEG", optimize=True, quality=85)
    else:
        if not img.mode == 'RGB':
            img.save(output_img,"PNG",optimize=True,quality=85)
        else:
            img.save(output_img, "JPEG", optimize=True, quality=85)
    return output_img

def make_thumbnail(image_file):
    img = Image.open(image_file)
    size = (320, 320)
    #base_path,filename = os.path.split(image_file)
    #outfile = os.path.splitext(filename)[0]+'_t.jpg'
    #fileobj = os.path.join(base_path,outfile)
    output_img = StringIO()
    img.thumbnail(size)
    if img.mode == 'RGB':
        img.save(output_img, "JPEG")
    else:
        img.save(output_img, "PNG")
    return output_img

def schma(category):

    if category.name.lower() in ['agricultural land','residential land','commercial land','hotel sites','industrial land']:
        return NewListingSchema

    else:
        return House
def editschma(category):

    if category.name.lower() in ['agricultural land','residential land','commercial land','hotel sites','industrial land']:
        return Propertyedit

    else:
        return HouseEdit


def get_categories():
    query = [(c.id,c.name) for c in DBSession.query(PropertyCategory).\
             filter(PropertyCategory.parent==None).all()]
    return query


def get_states():
    query = [(c.id,c.name) for c in DBSession.query(State).all()]
    return query


@view_config(route_name="get_lgas",renderer="json")
def get_lga(request):
    subs = []
    id = request.params.get('id')
    state = State.get_by_id(id)
    for lga in state.lga.all():
        d={"value":lga.id,"label":lga.name}
        subs.append(d)
    return subs


class Add(object):

    def __init__(self, request):
        self.request = request
        self.session = request.session

    @view_config(route_name="add_listings",renderer = "buddy:templates/listing/new_listing.mako", permission="post")
    def postproperty(self):
        # Find out total listing by user
        # Check if he has exceeded the allowed no of listing. Basically, if there's no active subscription
        # a total of 5 listing is allowed per account
        if not self.request.user.active_subscription:
            # User doesn't have an active subscription
            if self.request.user.total_listings >= 5:
                self.session.flash("danger; You have reached the maximum allowed listing for free account."
                                   " Upgrade your account now to list more properties")
                return HTTPFound(location=self.request.route_url('pricing'))

        title = 'Add properties for sale or rent'
        form = Form(self.request, schema=NewListingSchema, defaults={'show_address':True,'price_available':True})
        categories = get_categories()
        states = get_states()
        dbsession = DBSession()

        if 'submit' in self.request.POST:
            category_id = self.request.POST['category_id']
            category = PropertyCategory.get_by_id(category_id)
            if not category:
                self.request.session.flash('info; Please select a category')
                return HTTPFound(location = self.request.route_url('add_listings'))
            form = Form(self.request, schema = schma(category))
            if form.validate():
                state = State.get_by_id(form.data['state_id'])
                lga = LGA.get_by_id(form.data['lga_id'])
                titled_area = form.data['area'].title()
                district = District.get_by_name(titled_area)
                if not district:
                    district = District(name=titled_area, lga_id=lga.id)
                    dbsession.add(district)
                    dbsession.flush()
                ptype = PropertyCategory.get_by_id(form.data['category_id'])
                listing = Listings(
                    name=urlify_name(form.data['title']),
                    title=form.data['title'],
                    listing_type = form.data['listing_type'],
                    user_id=self.request.user.id,
                    address=form.data['address'],
                    show_address=form.data['show_address'],
                    price_available=form.data['price_available'],
                    price=form.data['price'],
                    deposit=form.data['deposit'],
                    agent_commission=form.data['agent_commission'],
                    price_condition=form.data['price_condition'],
                    transaction_type=form.data['transaction_type'],
                    available_from=form.data['available_from'],
                    body=form.data['body'],
                    modified=func.now()
                )
                dbsession.add(listing)
                if self.request.user.is_verified:
                    listing.approved = True
                dbsession.flush()
                res = Property_extras(
                    listing_id=listing.id,
                    area_size=form.data['area_size'],
                )
                dbsession.add(res)
                if category.name.lower() not in ['agricultural land','residential land','commercial land','hotel sites','industrial land']:
                    res.bedroom = form.data['bedroom']
                    res.bathroom = form.data['bathroom']
                    res.total_room = form.data['total_room']
                    res.floor_no = form.data['floor_no']
                    res.total_floor = form.data['total_floor']
                    res.year_built = form.data['year_built']
                    res.covered_area = form.data['covered_area']
                    res.furnished = form.data['furnished']
                    res.car_spaces = form.data['car_spaces']
                #if form.data['features']:
                #    for f in form.data['features']:
                #        t = dbsession.query(Features).get(f)
                #        res.features.append(t)
                ptype.listings.append(listing)
                state.listings.append(listing)
                lga.listings.append(listing)
                district.listings.append(listing)
                if self.request.user.parent:
                    self.request.user.parent.balance += 1000
                dbsession.flush()

                self.request.session.flash('success; Your property have been saved. Use the form below to add pictures to your property')
                return HTTPFound(location=self.request.route_url('step2', name=listing.name))

            return dict(form=FormRenderer(form),states=states, categories=categories,
                    title=title)
        return dict(form=FormRenderer(form), states=states, categories=categories,
                    title=title)

    @view_config(route_name = "step2", renderer="buddy:templates/listing/step2.mako",permission="edit")
    def step2(self):
        title = "Picture Upload"
        name = self.request.matchdict['name']
        listing = Listings.get_by_name(name)
        features = DBSession.query(Feature_types).all()
        listing_extra = listing.property_extra
        defaults = dict()
        for i in [f.id for f in listing.property_extra.features]:
            defaults[i] = True
        if not listing:
            self.request.session.flash('info; No property added')
            return HTTPFound(location = self.request.route_url('add_listing'))
        form = Form(self.request)
        form2 = Form(self.request)
        if 'save_features' in self.request.POST:
            posted_features = [i for i in self.request.params if len(i)<3]
            if posted_features:
                for i, cat in enumerate(listing.property_extra.features):
                    if cat.id not in posted_features:
                        del listing.property_extra.features[i]
                for f in posted_features:
                    t = DBSession.query(Features).get(f)
                    listing_extra.features.append(t)
                DBSession.flush()
                self.request.session.flash('success; Features saved too')
                return HTTPFound(location =self.request.route_url('account-listings'))
            self.request.session.flash('success; Listing saved')
            return HTTPFound(location=self.request.route_url('account-listings'))
        return dict(form=FormRenderer(form),form2 = FormRenderer(form2),
                    listing=listing, up=up(self.request,listing), features=features, title=title)

    @view_config(route_name="edit_listing",renderer="buddy:templates/listing/edit_listing.mako",permission="edit")
    def edit_listing(self):
        name = self.request.matchdict['name']
        listing = Listings.get_by_name(name)
        if not listing:
            return HTTPNotFound()
        lgas = [(region.id, region.name) for region in listing.state.lga.all()]
        category = PropertyCategory.get_by_id(listing.category_id)
        title = "Edit "+listing.title
        if not listing.status:
            self.session.flash("info; You can no longer edit this listing because you marked it as sold")
            return HTTPFound(location="/")
        categories = get_categories()
        states = get_states()
        if listing.category.name.lower()=="residential land":
            subcategories = [(listing.category.id, listing.category.name)]
        elif listing.category.name.lower() in ['residential house','flat']:
            subcategories = [(sub.id,sub.name) for sub in listing.category.parent.children if sub.name.lower()!='residential land']
        elif listing.category.parent.name.lower()=='agricultural':
            subcategories = [(listing.category.id,listing.category.name)]
        elif listing.category.name.lower() in ['commercial land','hotel sites','industrial land']:
            subcategories = [(sub.id,sub.name) for sub in listing.category.parent.children if sub.name.lower() in
                             ['commercial land','hotel sites','industrial land']]
        else:
            subcategories = [(sub.id,sub.name) for sub in listing.category.parent.children if sub.name.lower() not in
                             ['commercial land','hotel sites','industrial land']]

        defaults = dict(bedroom=listing.property_extra.bedroom,
                        bathroom=listing.property_extra.bathroom,
                        total_floor=listing.property_extra.total_floor,
                        total_room=listing.property_extra.total_room,
                        covered_area=listing.property_extra.covered_area,
                        area_size=listing.property_extra.area_size,
                        car_spaces=listing.property_extra.car_spaces,
                        floor_no=listing.property_extra.floor_no,
                        year_built=listing.property_extra.year_built,
                        body=listing.body,
                        dist = listing.district.name
                        )
        form = Form(self.request, schema=editschma(category), obj=listing, defaults=defaults)
        if 'submit' in self.request.POST and form.validate():
            form.bind(listing)
            listing.category_id = form.data['subcategory_id']
            listing.state_id = form.data['state_id']
            listing.lga_id = form.data['lga_id']
            district = District.get_by_name(form.data['dist'])
            if not district:
                district = District(name=form.data['dist'], lga_id=form.data['lga_id'])
                DBSession.add(district)
                DBSession.flush()
            listing.district_id = district.id
            listing.declined = False
            listing.modified = func.now()
            DBSession.flush()
            self.request.session.flash('success; Your property have been saved. Add more pictures below')
            return HTTPFound(location=self.request.route_url('step2', name=listing.name))

        return dict(form=FormRenderer(form), categories=categories, subcategories=subcategories,
             title=title, states=states, lgas=lgas, listing=listing)


@view_config(route_name="listing_upload")
def uploader(request):
    listing_id = request.matchdict['listing_id']
    listing = Listings.get_by_id(listing_id)
    if not listing:
        request.session.flash('warning;  An error occured')
        return HTTPFound(location=request.route_url('step2', name=listing.name))
    form = Form(request,schema=ListingUpload)
    if request.POST:
        files = request.POST.items()
        for file in files[1:]:
            data = StringIO(file[1].file.read())
            optimized_data = optimize(data)
            resized_data = make_thumbnail(data)
            data.close()
            filename = request.storage.save_file_io(optimized_data,file[1].filename,randomize=True, folder="listings")
            optimized_data.close()
            thumbname = request.storage.save_file_io(resized_data,file[1].filename,randomize=True,folder="thumbs")
            resized_data.close()
            pix = Photos(
                filename=filename,
                thumbnail=thumbname
            )
            DBSession.add(pix)
            listing.pictures.append(pix)

        DBSession.flush()
        return HTTPSeeOther(location=request.route_url('step2', name=listing.name))
    request.session.flash('warning;  An error occured')
    return HTTPFound(location=request.route_url('step2',name=listing.name))


@view_config(route_name="delete_upload", permission="edit")
def deleteupload(request):
    photo_id = request.matchdict['photo_id']
    name = request.matchdict['name']
    photo = DBSession.query(Photos).filter_by(id=photo_id).first()
    request.storage.delete(photo.filename)
    request.storage.delete(photo.thumbnail)
    DBSession.delete(photo)
    return HTTPFound(location=request.route_url('step2', name=name))


def up(request, listing):
    return render('buddy:templates/listing/uploadrender.mako',
                  dict(
                      files=listing.pictures.all()
                      ),
                  request=request)

