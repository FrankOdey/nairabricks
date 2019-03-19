'''from pyramid.view import view_config
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from buddy.models.properties_model import State, Listings
from buddy.models import DBSession
from buddy.models.city_model import Locality, LocalRating, LocalFeatureRating, FeatureToRate, CityPicCategory, \
    LocalPictures
from webhelpers.paginate import PageURL_WebOb, Page
from pyramid.renderers import reify
from pyramid.httpexceptions import HTTPFound
from buddy.views.local.schema import CreateLocal, PicUploadSchema
from buddy.utils.url_normalizer import urlify_name

def get_states():
    return DBSession.query(State).all()


class ListLocal(object):
    def __init__(self,request):
        self.request = request
        self.session=request.session
        self.db = DBSession()

    @view_config(route_name="list_local", renderer="buddy:templates/local/list.mako")
    def List(self):

        title = u'Cities'

        states = get_states()

        return dict(states=states,title=title)


class ViewLocal(object):
    def __init__(self,request):
        self.request = request
        self.session=request.session
        self.db = DBSession()

    @view_config(route_name="view_local", renderer="buddy:templates/local/view.mako")
    def view(self):
        form = Form(self.request)
        name = self.request.matchdict['name']
        city = Locality.get_by_name(name)
        if not city:
            self.session.flash('warning; No such city')
            return HTTPFound(location='/')
        ftypes = self.db.query(FeatureToRate).all()
        title = city.city_name + " Rating And Review"
        active_listings = DBSession.query(Listings).filter(Listings.state==city.state).\
            filter(Listings.city==city.city_name).filter(Listings.status==True).all()
        pastsales = DBSession.query(Listings).filter(Listings.state_id==city.state_id). \
            filter(Listings.city==city.city_name).filter(Listings.status==False).all()
        page_url = PageURL_WebOb(self.request)
        active_paginator = Page(active_listings,
                         page=int(self.request.params.get("page", 1)),
                         items_per_page=10,
                         url=page_url)
        pastsales_paginator = Page(pastsales,
                                page=int(self.request.params.get("page", 1)),
                                items_per_page=10,
                                url=page_url)

        return dict(title=title,form=FormRenderer(form),
                    ftypes=ftypes,locality=city, active_paginator=active_paginator,pastsales_paginator=pastsales_paginator)
    @reify
    def states(self):
        return get_states()

    @view_config(route_name="add_city_pictures", permission="post")
    def add_pictures(self):
        form = Form(self.request, schema = PicUploadSchema)
        name = self.request.matchdict['name']
        city = Locality.get_by_name(name)
        if not city:
            self.session.flash('info;City not found')
            return HTTPFound(location = sellf.request.route_url('home'))
        if "form_submitted" in self.request.POST and form.validate():
            filename = self.request.storage.save(self.request.POST['filename'],randomize=True)
            pics = LocalPictures(
                local_id = city.id,
                category_id = form.data['category_id'],
                title = form.data['title'],
                filename = filename
            )
            DBSession.add(pics)
            DBSession.flush()
            self.session.flash("success;success")
            return HTTPFound(location = self.request.route_url('city_pictures',name=name))
        return HTTPFound(location = self.request.route_url('city_pictures',name=name))

    @view_config(route_name="city_pictures", renderer="buddy:templates/local/photos.mako")
    def city_pictures(self):
        form = Form(self.request)
        name = self.request.matchdict['name']
        city = Locality.get_by_name(name)
        if not city:
            self.session.flash('info; City not found')
            return HTTPFound(location=self.request.route_url('home'))
        cate = [(c.id, c.name) for c in DBSession.query(CityPicCategory).all()]
        return dict(pictures=city.pictures,locality=city, form = FormRenderer(form),cate=cate, photos="photos")
    @view_config(route_name="city_properties", renderer="buddy:templates/local/properties.mako")
    def properties(self):
        name = self.request.matchdict['name']
        city = Locality.get_by_name(name)
        if not city:
            self.session.flash('warning; No such city')
            return HTTPFound(location='/')
        title = "Properties in %s(%s)"%(city.city_name, city.state.name)
        active_listings = DBSession.query(Listings).filter(Listings.state==city.state).\
            filter(Listings.city==city.city_name).filter(Listings.status==True).all()
        pastsales = DBSession.query(Listings).filter(Listings.state_id==city.state_id). \
            filter(Listings.city==city.city_name).filter(Listings.status==False).all()
        page_url = PageURL_WebOb(self.request)
        active_paginator = Page(active_listings,
                         page=int(self.request.params.get("page", 1)),
                         items_per_page=10,
                         url=page_url)
        pastsales_paginator = Page(pastsales,
                                page=int(self.request.params.get("page", 1)),
                                items_per_page=10,
                                url=page_url)

        return dict(title=title,locality=city,pro="property", active_paginator=active_paginator,
                    pastsales_paginator=pastsales_paginator)

class AddLocal(object):
    def __init__(self,request):
        self.request = request
        self.session = request.session

    @view_config(route_name="add_local", renderer = "buddy:templates/local/create_local.mako")
    def add_local(self):
        title =' Add locality'
        form = Form(self.request, schema=CreateLocal)
        if 'form-submitted' in self.request.POST and form.validate():
            local = Locality(name = urlify_name(form.data['city_name']),
                             city_name = form.data['city_name'],
                          state_id = form.data['state_id'])

            DBSession.add(local)
            DBSession.flush()
            self.session.flash('success; City created')
            return HTTPFound(location=self.request.route_url('add_local'))
        return dict(form = FormRenderer(form),states=get_states(),title=title)

    @view_config(route_name="delete_local")
    def delete_loc(self):
        name = self.request.matchdict['name']
        local = Locality.get_by_name(name)
        if not local:
            self.session.flash('warning; City not found')
            return HTTPFound(location=self.request.route_url('list_local'))
        DBSession.delete(local)
        DBSession.flush()
        self.session.flash('success; City deleted')
        return HTTPFound(location=self.request.route_url('list_local'))


class Rate(object):
    def __init__(self, request):
        self.request = request
        self.session = request.session
        self.db = DBSession()

    @view_config(route_name="rate_local",permission="post", renderer="buddy:templates/local/rating.mako")
    def rate(self):
        form = Form(self.request)
        name = self.request.matchdict['name']
        locality = Locality.get_by_name(name)
        if not locality:
            self.session.flash('warning; City does not exist')
            return HTTPFound(location="/")
        if locality.rating:
            for rating in locality.rating:
                if self.request.user == rating.user:
                    self.session.flash("info; You have rated this city before now. You cannot rate twice")
                    return HTTPFound(location = self.request.route_url('view_local',name=locality.name))
        query = self.db.query(FeatureToRate)
        ftypes = query.all()
        torate = query.filter(FeatureToRate.parent!=None).all()
        title = "Rate " +locality.city_name
        if 'form_submitted' in self.request.POST:
            for f in torate:
                if float(self.request.params.get(f.name))<2:
                    self.session.flash('info; Any rating less than 2 stars is not allowed')
                    return HTTPFound(location = self.request.route_url('rate_local',name=locality.name))
            Local_rating = LocalRating(
                local_id=locality.id,
                user_id = self.request.user.id,
                title = self.request.params.get('title',''),
                review = self.request.params.get('review'),
            )
            self.db.add(Local_rating)
            self.db.flush()
            for f in torate:
                r = LocalFeatureRating(
                        rating_id = Local_rating.id,
                        feature_id= f.id,
                        rating = self.request.params.get(f.name),
                        )
                self.db.add(r)
            self.db.flush()
            return HTTPFound(location=self.request.route_url('view_local', name=locality.name))
        return dict(form=FormRenderer(form),locality=locality,ftypes=ftypes,title=title)

    @view_config(route_name="delete_local_rating")
    def delete_rating(self):
        name = self.request.matchdict['name']
        id = self.request.matchdict['rating_id']
        locality = Locality.get_by_name(name)
        if not locality:
            self.session.flash("info; No such city")
            return HTTPFound(location='/')
        rating = DBSession.query(LocalRating).get(id)
        if rating:
            DBSession.delete(rating)
            self.session.flash('success; rating deleted')
            return HTTPFound(location=self.request.route_url('view_local',name=name))
        self.session.flash("danger; No rating on this city")
        return HTTPFound(location=self.request.route_url('view_local',name=name))

    @view_config(route_name="edit_local_rating",renderer="buddy:templates/local/edit_rating.mako")
    def edit_local_rating(self):
        form = Form(self.request)
        name = self.request.matchdict['name']
        id = self.request.matchdict['rating_id']
        locality = Locality.get_by_name(name)
        if not locality:
            self.session.flash("info; No such city")
            return HTTPFound(location='/')
        rating = DBSession.query(LocalRating).get(id)
        query = self.db.query(FeatureToRate)
        ftypes = query.all()
        torate = query.filter(FeatureToRate.parent!=None).all()
        title = "Edit Rating of " +locality.city_name
        if 'form_submitted' in self.request.POST:
            for f in torate:
                if float(self.request.params.get(f.name))<2:
                    self.session.flash('info; Any rating less than 2 stars is not allowed')
                    return HTTPFound(location = self.request.route_url('rate_local',name=locality.name))
            rating.title = self.request.params.get('title')
            rating.review = self.request.params.get('review')
            self.db.add(rating)
            for f in torate:
                feature_rating = DBSession.query(LocalFeatureRating).filter_by(feature_id=f.id).first()
                feature_rating.rating = self.request.params.get(f.name)
                self.db.add(f)
            self.db.flush()
            return HTTPFound(location=self.request.route_url('view_local', name=locality.name))
        return dict(rating=rating, ftypes=ftypes,torate=torate,title=title,locality=locality, form=FormRenderer(form))
'''