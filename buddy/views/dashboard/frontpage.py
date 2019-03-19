#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pyramid.view import view_config
from buddy.models.resources import FrontPix
from buddy.models import *
from pyramid.httpexceptions import HTTPFound, HTTPSeeOther
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.views.dashboard.schema import FrontPixUpload
from pyramid.renderers import render
import transaction

class FrontPicture(object):
    def __init__(self,request):
        self.request = request
        
    @view_config(route_name='add_frontpage_picture',
             renderer='buddy:templates/dashboard/pictures/add.mako')
    def add(self):
        form = Form(self.request)
        p=up(self.request)
        return dict(
            title="Add picture to home background",
            up=p,
            form = FormRenderer(form))
    
@view_config(route_name="frontpage_upload")
def uploader(request):
    form = Form(request,schema=FrontPixUpload)
    if 'submit' in request.POST and form.validate():
        filename=request.storage.save(request.POST['pics'], folder='frontpage',randomize=True)
        pix = FrontPix(
            filename=filename)
        with transaction.manager:
            DBSession.add(pix)
            return HTTPSeeOther(location=request.route_url('add_frontpage_picture'))
    request.session.flash('warning;  An error occured')
    return HTTPFound(location=request.route_url('add_frontpage_picture'))

@view_config(route_name="delete_frontpage_upload", permission="post")
def deleteuploadfile(request):
    id = request.matchdict['id']
    pix = DBSession.query(FrontPix).filter(FrontPix.id==id).first()
    request.storage.delete(pix.filename)
    DBSession.delete(pix)
    DBSession.flush()
    return HTTPFound(location=request.route_url('add_frontpage_picture'))

def up(request):
    files = DBSession.query(FrontPix).all()

    return render('buddy:templates/dashboard/pictures/uploadrender.mako',
                  dict(
                      files=files
                      ),
                  request=request)
