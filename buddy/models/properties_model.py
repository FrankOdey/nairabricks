from sqlalchemy import Table, func
from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy.orm import subqueryload
from sqlalchemy.orm import backref
from sqlalchemy.orm import relationship
from sqlalchemy.types import Integer, Float, Enum
from sqlalchemy.types import Boolean
from sqlalchemy.types import Unicode, DateTime
from sqlalchemy.types import UnicodeText
from webhelpers.paginate import PageURL_WebOb, Page
from webhelpers.date import time_ago_in_words
from pyramid.security import (ALL_PERMISSIONS,
                              Allow,Authenticated)
from buddy.models import *
from buddy.models.resources import Content
from buddy.utils.url_normalizer import url_normalizer
import datetime
import random
from buddy.utils.tools import flatten



alphabet = u'NB-'
NUMBER = u'123456789'

def make_random_number(length):
    'Return a random number(number) of a given length'
    return ''.join(random.choice(NUMBER) for n in xrange(length))

def make_random_unique_number(length, is_unique):
    'Return a random number given a function that checks for uniqueness'
    # Initialize
    iterationCount = 0
    permutationCount = len(NUMBER) ** length
    while iterationCount < permutationCount:
        # Make randomID
        randomID = alphabet + make_random_number(length)
        iterationCount += 1
        # If our randomID is unique, return it
        if is_unique(randomID):
            return randomID
    # Raise exception if we have no more permutations left
    raise RuntimeError('Could not create a unique string')

        
def is_unique(serial):
    reg = DBSession.query(Listings).filter(Listings.serial==serial).first()
    if reg:
        return False
    return True


class PropertyCategory(Base):
    """Listing Category Entity Model"""
    __tablename__="property_category"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80), nullable=False)
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("PropertyCategory",
                        cascade="all",
                        backref=backref("parent", remote_side=id)
                    )

    def __init__(self, name, parent=None):
        self.name = name
        self.parent = parent

    @classmethod
    def get_by_id(cls,id):
        return DBSession.query(cls).filter(cls.id==id).first()

    @classmethod
    def get_by_name(cls,name):
        return DBSession.query(cls).filter(cls.name==name).first()

    @classmethod
    def all(cls):
        return DBSession.query(cls).order_by(cls.name).all()

    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        return Page(cls.all(), page, url=page_url,
                    items_per_page=25)

    
class State(Base):
    """State Model """
    __tablename__="state"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(100))

    def __init__(self, name):
        self.name = name

    @staticmethod
    def extract_states(s_string):

        states = [s.title() for s in s_string.split(',')]

        states = set(states)

        return states

    @classmethod
    def get_by_name(cls, s_name):
        s= DBSession.query(cls).filter(cls.name == s_name)
        return s.first()

    @classmethod
    def get_by_id(cls, s_id):
        s = DBSession.query(cls).filter(cls.id == s_id)
        return s.first()

    @classmethod
    def create_state(cls, s_string):
        state_list = cls.extract_states(s_string)
        states = []

        for s_name in state_list:
            state = cls.get_by_name(s_name)
            if not state:
                state = State(name=s_name)
                DBSession.add(state)
            states.append(state)

        return states

    @classmethod
    def all(cls):
        return DBSession.query(cls).\
    order_by(cls.name)


    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        return Page(cls.all(), page, url=page_url,
                    items_per_page=40)


class LGA(Base):
    """Local Government Area"""
    __tablename__ = "lga"
    id = Column(Integer, primary_key=True)
    state_id = Column(Integer, ForeignKey("state.id"),index=True)
    state= relationship("State",backref = backref("lga", lazy="dynamic",
                                                  cascade="all, delete-orphan"))
    name = Column(Unicode(80))

    def __init__(self, name, state_id):
        self.name = name
        self.state_id=state_id

    @staticmethod
    def extract_lga(lga_string):

        lga = [lga.title() for lga in lga_string.split(',')]

        lga = set(lga)

        return lga
    @classmethod
    def get_by_name(cls, name):
        lga = DBSession.query(cls).filter(cls.name == name)
        return lga.first()

    @classmethod
    def get_by_id(cls, id):
        lga = DBSession.query(cls).filter(cls.id == id)
        return lga.first()

    @classmethod
    def create_lga(cls, state_id,lga_string):
        lga_list = cls.extract_lga(lga_string)
        lgas = []

        for name in lga_list:
            lga = cls.get_by_name(name)
            if not lga:
                lga = LGA(name=name, state_id=state_id)
                DBSession.add(lga)
                DBSession.flush()

            lgas.append(lga)

        return lgas

    @classmethod
    def all(cls, state_id):
        return DBSession.query(LGA).filter_by(state_id=state_id).\
    order_by(LGA.name)


    @classmethod
    def get_paginator(cls, request,state_id,page=1):
        page_url = PageURL_WebOb(request)
        return Page(cls.all(state_id), page, url=page_url,
                    items_per_page=10)


local_recommended_for = Table('local_recommended_for', Base.metadata,
    Column('recommended_for_id', Integer, ForeignKey('recommended_for.id')),
    Column('district_id', Integer, ForeignKey('district.id'))
)


class District(Base):
    """Local Government Area District"""
    __tablename__ = "district"
    id = Column(Integer, primary_key=True)
    lga_id = Column(Integer, ForeignKey("lga.id"),index=True)
    lga= relationship("LGA",backref = backref("district", lazy="dynamic",
                                                  cascade="all, delete-orphan"))
    name = Column(Unicode(80))

    recommended_for = relationship("RecommendedFor", secondary=local_recommended_for,
                                   backref="district")
    rating = relationship('DistrictRating', backref='district', cascade="all, delete-orphan")

    def __init__(self, name, lga_id):
        self.name = name
        self.lga_id = lga_id

    @staticmethod
    def extract_district(district_string):

        districts = [district.title() for district in district_string.split(',')]

        districts = set(districts)

        return districts

    @classmethod
    def get_by_name(cls, name):
        name = name.title()
        district = DBSession.query(cls).filter(cls.name == name)
        return district.first()

    @classmethod
    def get_by_id(cls, id):
        district = DBSession.query(cls).filter(cls.id == id)
        return district.first()

    @classmethod
    def create_district(cls, lga_id,district_string):
        district_list = cls.extract_district(district_string)
        districts = []

        for name in district_list:
            district = cls.get_by_name(name)
            if not district:
                district = District(name=name, lga_id=lga_id)
                DBSession.add(district)
            districts.append(district)

        return districts

    @classmethod
    def all(cls, lga_id):
        return DBSession.query(District).filter_by(lga_id=lga_id).\
    order_by(District.name)


    @classmethod
    def get_paginator(cls, request,lga_id,page=1):
        page_url = PageURL_WebOb(request)
        return Page(cls.all(lga_id), page, url=page_url,
                    items_per_page=10)
    @property
    def overall_avg(self):
        if self.rating:
            return round(sum(x.avg_rating for x in self.rating)/len(self.rating)+0.0,1)
        return ''

    @property
    def ratingByFeature(self):
        d={}
        if self.rating:
            for x in self.rating:
                for k, v in x.ratingByFeature.iteritems():
                    d.setdefault(k,[]).append(v)
        r = dict()
        for k,v in d.iteritems():
            r[k] = round(sum(list(flatten(v)))/(len(list(flatten(v)))+0.0),1)
        return r
    @classmethod
    def get_by_id(cls,id):
        return DBSession.query(cls).filter(cls.id==id).first()

class RecommendedFor(Base):
    __tablename__ = "recommended_for"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    image = Column(Unicode(80))



class DistrictPicCategory(Base):
    __tablename__ = "district_pic_category"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))

    def __init__(self, name):
        self.name = name

class DistrictPictures(Base):
    __tablename__ = 'district_pictures'
    id = Column(Integer, primary_key=True)
    district_id = Column(Integer, ForeignKey('district.id'),index=True)
    district = relationship("District", backref=backref("pictures", cascade="all, delete, delete-orphan"))
    category_id = Column(Integer, ForeignKey("district_pic_category.id"), index=True)
    category = relationship("DistrictPicCategory", backref=backref("pictures", cascade="all, delete, delete-orphan"))
    filename = Column(Unicode(80))
    title = Column(Unicode(80))


class DistrictFeatureToRate(Base):
    __tablename__ = 'district_feature_to_rate'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("DistrictFeatureToRate",
                            cascade="all",
                            backref=backref("parent", remote_side=id)
    )
    def __init__(self, name, parent=None):
        self.name = name
        self.parent = parent

    @classmethod
    def get_by_name(cls, name):
        return DBSession.query(cls).filter(cls.name==name).first()

class DistrictRating(Base):
    __tablename__ = 'district_rating'
    id = Column(Integer, primary_key=True)
    district_id = Column(Integer, ForeignKey('district.id'),index=True)
    title = Column(Unicode(80))
    review = Column(UnicodeText)
    user_id = Column(Integer, ForeignKey('users.id'),index=True)
    created = Column(DateTime, default=func.now())
    modified = Column(DateTime, onupdate=func.now())
    user = relationship('Users', backref=backref('district_rating', cascade="all, delete-orphan"))
    feature_rating = relationship("DistrictFeatureRating", backref="district_rating", cascade="all, delete, delete-orphan")

    @property
    def avg_rating(self):
        return round(sum(x.rating for x in self.feature_rating)/len(self.feature_rating)+0.0,1)

    @property
    def ratingByFeature(self):
        d = dict()
        for x in self.feature_rating:
            d.setdefault(x.feature.name,[]).append(x.rating)
        return d

class DistrictFeatureRating(Base):
    """A table containing the user and the local & feature table id with rating"""
    __tablename__ = 'district_feature_rating'
    rating_id = Column(Integer, ForeignKey('district_rating.id'),primary_key=True)
    feature_id = Column(Integer, ForeignKey('district_feature_to_rate.id'), primary_key=True)
    rating = Column(Float)
    feature = relationship('DistrictFeatureToRate',backref="district_feature_rating")

featured_properties = Table('featured_properties', Base.metadata,
    Column('featured_id', Integer, ForeignKey("featured_content.id")),
    Column('listing_id',Integer, ForeignKey("listings.id"))
    )


class Listings(Content):
    """ Listing Entity Table """
    __tablename__= "listings"
    id = Column(Integer, ForeignKey('content.id'),primary_key=True)
    serial = Column(Unicode(80),default=lambda:make_random_unique_number(6,is_unique))
    #for_sale = Column(Boolean)
    listing_type = Column(Enum(u'For sale',u'For rent',u'Short let'))
    category_id = Column(Integer, 
                         ForeignKey("property_category.id"),
                         index=True)
    category = relationship("PropertyCategory",
                            backref = backref("listings", lazy="dynamic",
                                              cascade="all, delete-orphan"))
    state_id = Column(Integer, ForeignKey("state.id"),index=True)
    state= relationship("State",backref = backref("listings", lazy="dynamic",
                                                  cascade="all, delete-orphan"))
    lga_id = Column(Integer, ForeignKey("lga.id"),index=True)
    lga= relationship("LGA",backref = backref("listings", lazy="dynamic",
                                                  cascade="all, delete-orphan"))
    district_id = Column(Integer, ForeignKey("district.id"),index=True)
    district= relationship("District",backref = backref("listings", lazy="dynamic",
                                                  cascade="all, delete-orphan"))
    approved = Column(Boolean,default=False)
    declined = Column(Boolean, default=False)
    city = Column(Unicode(80))
    area = Column(Unicode(80))
    longitude = Column(Integer)
    latitude = Column(Integer)
    address = Column(Unicode(80))
    show_address = Column(Boolean, default=True)
    price = Column(Integer)
    sold_price = Column(Integer)
    deposit = Column(Unicode(80))
    price_available = Column(Boolean,default=True)
    price_condition = Column(Unicode(80))
    agent_commission = Column(Unicode(80))
    available_from = Column(Unicode(80))
    status = Column(Boolean, default=True)
    hospital = Column(Unicode(24))
    school = Column(Unicode(24))
    market = Column(Unicode(24))
    bank = Column(Unicode(24))
    serviced = Column(Boolean, default=False)
    transaction_type = Column(Unicode(50))  #resale or new property
    property_extra = relationship('Property_extras',uselist=False,backref="listings")
    __mapper_args__ = {'polymorphic_identity':'listing'}

    @classmethod
    def get_query(cls,with_joinedload=True):
        query = DBSession.query(cls)
        if with_joinedload:
            query = query.options(subqueryload(cls.category))
        return query
    
    @classmethod
    def get_by_id(cls, listing_id, with_joinedload=True):
        query = cls.get_query(with_joinedload)
        return query.filter(cls.id == listing_id).first()
    
    @classmethod
    def listing_bunch(cls, order_by, how_many=2000, with_joinedload=True):
        query = cls.get_query(with_joinedload)
        query = query.filter_by(approved = True).filter_by(declined=False).filter_by(status=True).order_by(order_by)
        return query.limit(how_many).all()


    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        search = cls.listing_bunch(cls.modified.desc())
        return Page(search, page, url=page_url,
                    items_per_page=10,item_count=len(search))

class Photos(Base):
    """Photo Entity Model"""
    __tablename__="photos"
    id = Column(Integer, primary_key=True)
    filename = Column(Unicode(100))
    thumbnail = Column(Unicode(100))
    listing_id = Column(Integer, ForeignKey("listings.id"))
    listing = relationship("Listings", backref=backref("pictures",lazy = "dynamic",
                                                        cascade="all,delete-orphan"))

property_extra_feature = Table('property_extra_feature', Base.metadata,
    Column('property_extra_id', Integer, ForeignKey('property_extras.id')),
    Column('feature_id', Integer, ForeignKey('features.id'))
)

class Property_extras(Base):

    __tablename__="property_extras"
    id = Column(Integer,primary_key=True)
    listing_id = Column(Integer,ForeignKey("listings.id"))
    floor_no = Column(Integer)
    total_floor = Column(Integer)
    total_room = Column(Integer)
    bedroom = Column(Integer)
    bathroom = Column(Integer)
    covered_area = Column(Integer)
    area_size = Column(Integer)
    furnished = Column(Boolean, default=False)
    year_built = Column(Integer)
    car_spaces = Column(Integer)
    features = relationship('Features',secondary=property_extra_feature)

class Feature_types(Base):
    """Property Feature Types"""
    __tablename__="feature_types"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    features = relationship("Features",cascade="all, delete-orphan", backref="feature_type")
    
    def __init__(self, name):
        self.name=name


class Features(Base):
    """ Property Features Models """
    __tablename__='features'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    image = Column(Unicode(80))
    description = Column(UnicodeText)
    #parent_id = Column(Integer, ForeignKey(id))
    #children = relationship("Features",
    #                    cascade="all",
    #                    backref=backref("parent", remote_side=id)
    #                )
    type_id = Column(Integer, ForeignKey("feature_types.id"))

class ListingFactory(Base):

    __tablename__ ='listing_factory'
    id = Column(Integer, primary_key=True)

    __acl__ = [(Allow, Authenticated, 'post'),
                (Allow, 'superadmin', ALL_PERMISSIONS),
                (Allow, 'admin',('admin','supermod','mod','edit')),
                (Allow, 'supermod',('supermod','mod')),
                (Allow, 'mod','mod')
    ]

    def __init__(self, request):
        if request.matchdict:
            self.__dict__.update(request.matchdict)

    def __getitem__(self, key):
        lis = Listings.get_by_name(key)
        if not lis:
            return
        lis.__parent__ = self
        lis.__name__ = key
        return lis