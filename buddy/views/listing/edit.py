'''#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'
from pyramid.view import view_config
from pyramid.renderers import render_to_response, render
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from pyramid.httpexceptions import HTTPFound,HTTPSeeOther
from buddy.utils.url_normalizer import urlify_name
from buddy.views.listing.schema import (
    Step1edit,ListingUpload)
from buddy.models import *
from buddy.models.properties_model import (Listings,Property_extras,
                                           State,
                                           Feature_types,Features,
                                           PropertyCategory,
                                           Photos, District)
from sqlalchemy.sql import func

def get_categories():
    query = [(c.id,c.name) for c in DBSession.query(PropertyCategory).\
             filter(PropertyCategory.parent==None).all()]
    return query

def get_states():
    query = [(c.id,c.name) for c in DBSession.query(State).all()]
    return query



class Edit(object):

    def __init__(self, request):
        self.request = request
        self.session = request.session


    @view_config(route_name="edit_step1",renderer="buddy:templates/listing/edit/step1_deprecated.mako",permission='edit')
    def step1(self):
        name = self.request.matchdict['name']
        listing = Listings.get_by_name(name)
        lgas =  [(region.id,region.name) for region in listing.state.lga.all() ]

        if not listing:
            self.session.flash("warning; listing not found")
            return HTTPFound(location="/")
        if not listing.status:
            self.session.flash("warning; You can no longer edit this listing")
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
        if not listing:
            self.session.flash('warning; Listing does not exist')
            return HTTPFound(location = self.request.route_url('listings'))
        form = Form(self.request, schema=Step1edit, obj=listing)

        if listing.district:
            district_name = listing.district.name
        else:
            district_name = None
        if 'next' in self.request.POST and form.validate():
            form.bind(listing)
            listing.category_id = form.data['subcategory_id']
            listing.state_id = form.data['state_id']
            listing.lga_id = form.data['lga_id']
            district = District.get_by_name(form.data['dist'])
            if not district:
                district = District(name=form.data['dist'],lga_id=form.data['lga_id'])
                DBSession.add(district)
                DBSession.flush()
            listing.district_id = district.id
            listing.declined = False
            listing.modified = func.now()
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('edit_step2', name=listing.name))
        return dict(form=FormRenderer(form), categories=categories,subcategories=subcategories,title="1st step Editing %s"%listing.title,
                    states=states,lgas=lgas, listing=listing,district_name=district_name)

    @view_config(route_name="edit_step2", renderer="buddy:templates/listing/edit/step2_deprecated.mako", permission="edit")
    def step2(self):

        ftypes = DBSession.query(Feature_types).all()
        distances = [(1,'Less than 1km'),(2,'Less than 2km'),(3,'Less than 3km'),(4,'Less than 4km'),
                     (5,'Less than 5km'),(6,'More than 5km')]
        name = self.request.matchdict['name']
        listing = Listings.get_by_name(name)
        title = title="2nd step Editing %s"%listing.title
        category = listing.category
        defaults = dict(bedroom=listing.property_extra.bedroom,
                        bathroom = listing.property_extra.bathroom,
                        total_floor = listing.property_extra.total_floor,
                        total_room = listing.property_extra.total_room,
                        covered_area = listing.property_extra.covered_area,
                        area_size = listing.property_extra.area_size,
                        car_spaces = listing.property_extra.car_spaces,
                        floor_no = listing.property_extra.floor_no,
                        year_built = listing.property_extra.year_built,
                        body=listing.body,
                        )
        d = [f.name for f in listing.property_extra.features]
        for i in d:
            defaults[i] = True

        form = Form(self.request,schema=schma(category),obj=listing, defaults =defaults)
        if 'next' in self.request.POST and form.validate():
            form.bind(listing)
            form.bind(listing.property_extra, exclude=['features'])
            if listing.category.name.lower() not in ['commercial land','hotel sites','industrial land',
                                        'agricultural land','residential land']:
                for i, cat in enumerate(listing.property_extra.features):
                    if cat.id not in form.data['features']:
                        del listing.property_extra.features[i]
                catids = [cat.id for cat in listing.property_extra.features]
                for cate in form.data['features']:
                    if cate not in catids:
                        t = DBSession.query(Features).get(cate)
                        listing.property_extra.features.append(t)
            if listing.user.is_verified:
                listing.approved = True
            DBSession.flush()
            return HTTPFound(location=self.request.route_url('edit_pix_upload', name=listing.name))
        return dict(form=FormRenderer(form),distances=distances,title=title, ftypes=ftypes,listing=listing,
                    category=category)

    @view_config(route_name = "edit_pix_upload", renderer="buddy:templates/listing/edit/step2.mako", permission="edit")
    def step3(self):
        title = "Picture Upload"
        form = Form(self.request)
        name = self.request.matchdict['name']
        listing= Listings.get_by_name(name)
        return dict(form=FormRenderer(form),listing=listing, up=up(self.request,[i.filename for i in listing.pictures.all()],listing),
                    title=title)

@view_config(route_name="edit_listing_upload")
def uploader(request):
    from buddy.views.listing.add import optimize,make_thumbnail
    import os.path
    name = request.matchdict['name']
    listing = Listings.get_by_name(name)
    if not listing:
        request.session.flash('warning; No listing with that name')
        return HTTPFound(location = '/')
    form2 = Form(request,schema=ListingUpload)
    if 'submit' in request.POST and form2.validate():
        #filename=request.storage.save_file(add_watermark(request.POST['pics'].file,'home/webcalc/nairabricks/buddy/static/nairabricksid.png'),request.POST['pics'].filename, randomize=True)
        ##add_watermark(request.storage.url(filename),'/static/nairabricksid.png')
        filename=request.storage.save(request.POST['pics'], randomize=True)
        mfile = os.path.abspath(request.storage.path(filename))
        optimize(mfile)
        make_thumbnail(mfile)
        thumbname = os.path.splitext(filename)[0]+'_t.jpg'
        photo = Photos(
            filename=filename,
            thumbnail = thumbname
        )
        listing.pictures.append(photo)
        DBSession.flush()
        return HTTPSeeOther(location=request.route_url('edit_pix_upload', name = listing.name))
    request.session.flash('warning;  An error occured')
    return HTTPFound(location=request.route_url('edit_pix_upload'))

@view_config(route_name="edit_delete_upload")
def deleteupload(request):
    name = request.matchdict['name']
    filename = request.matchdict['filename']
    listing = Listings.get_by_name(name)
    photo = listing.pictures.filter_by(filename=filename).first()
    DBSession.delete(photo)
    return HTTPFound(location=request.route_url('edit_pix_upload', name=listing.name))

def up(request, files, listing):
    files=files
    session=request.session
    if 'files' in session:
        files=session['files']
    return render('buddy:templates/listing/edit/uploadrender.mako',
                  dict(
                      files=files,
                      listing = listing,
                      ),
                  request=request)


'''