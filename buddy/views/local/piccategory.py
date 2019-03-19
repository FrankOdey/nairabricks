
'''
__author__ = 'ephraim'
from pyramid.view import view_config
from buddy.models.city_model import Locality,CityPicCategory
from buddy.models import DBSession
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.views.local.schema import PicCategorySchema
from pyramid.httpexceptions import HTTPFound

@view_config(route_name="list_citypiccategory", renderer="buddy:templates/local/listcitypiccategory.mako")
def list(request):
    cate = DBSession.query(CityPicCategory).all()
    form = Form(request)
    return dict(categories = cate, form=FormRenderer(form), title="City Pics Category")

@view_config(route_name="add_citypiccategory")
def add(request):
    form = Form(request, schema=PicCategorySchema)
    if "form_submitted" in request.POST and form.validate():
        cate = CityPicCategory(name=form.data['name'])
        DBSession.add(cate)
        DBSession.flush()
        request.session.flash("success; success")
        return HTTPFound(location=request.route_url('list_citypiccategory'))
    request.session.flash("success; success")
    return HTTPFound(location=request.route_url('list_citypiccategory'))

@view_config(route_name="edit_citypiccategory",renderer="buddy:templates/local/editcitypiccategory.mako")
def edit(request):
    id = request.matchdict['id']
    cate = DBSession.query(CityPicCategory).get(id)
    if not cate:
        request.session.flash("warning; Category not found")
        return HTTPFound(location=request.route_url('list_citypiccategory'))
    form = Form(request, schema=PicCategorySchema, obj=cate)
    if "form_submitted" in request.POST and form.validate():
        cate.name = form.data['name']
        DBSession.flush()
        request.session.flash("success; success")
        return HTTPFound(location=request.route_url('list_citypiccategory'))

    return dict(form = FormRenderer(form), cate=cate)

@view_config(route_name="delete_citypiccategory")
def deletepic(request):
    id = request.matchdict['id']
    cate =DBSession.query(CityPicCategory).get(id)
    if not cate:
        request.session.flash("warning; Category not found")
        return HTTPFound(location=request.route_url('list_citypiccategory'))
    DBSession.delete(cate)
    DBSession.flush()
    return HTTPFound(location=request.route_url('list_citypiccategory'))
'''