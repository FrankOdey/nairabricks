'''from sqlalchemy import Table
from sqlalchemy import Column
from sqlalchemy import ForeignKey, func
from sqlalchemy.types import Integer, DateTime, Float, Enum, Unicode,UnicodeText, Boolean
from sqlalchemy.orm import backref,relationship
from buddy.models.properties_model import State
from buddy.models.user_model import Users
from buddy.models.resources import Content
from buddy.models import *
from buddy.utils.url_normalizer import url_normalizer
from buddy.utils.tools import flatten


local_recommended_for = Table('local_recommended_for', Base.metadata,
    Column('recommended_for_id', Integer, ForeignKey('recommended_for.id')),
    Column('local_id', Integer, ForeignKey('local.id'))
)

class Locality(Content):
    __tablename__ = "local"
    id = Column(Integer, ForeignKey('content.id'),primary_key=True)
    state_id = Column(Integer, ForeignKey("state.id"),index=True)
    state= relationship(State, backref=backref("local",
                                               cascade="all, delete-orphan"))
    city_name = Column(Unicode(80))
    recommended_for = relationship("RecommendedFor", secondary=local_recommended_for,
                                   backref="local")
    pictures = relationship('LocalPictures', backref='local', cascade="all, delete-orphan")
    rating = relationship('LocalRating', backref='local', cascade="all, delete-orphan")
    __mapper_args__ = {'polymorphic_identity':'city'}
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

class CityPicCategory(Base):
    __tablename__ = "city_pic_category"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))

    def __init__(self, name):
        self.name = name

class LocalPictures(Base):
    __tablename__ = 'local_pix'
    id = Column(Integer, primary_key=True)
    local_id = Column(Integer, ForeignKey('local.id'),index=True)
    category_id = Column(Integer, ForeignKey("city_pic_category.id"), index=True)
    category = relationship("CityPicCategory", backref=backref("pictures", cascade="all, delete, delete-orphan"))
    filename = Column(Unicode(80))
    title = Column(Unicode(80))

class FeatureToRate(Base):
    __tablename__ = 'feature_to_rate'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("FeatureToRate",
                            cascade="all",
                            backref=backref("parent", remote_side=id)
    )
    def __init__(self, name, parent=None):
        self.name = name
        self.parent = parent

    @classmethod
    def get_by_name(cls, name):
        return DBSession.query(cls).filter(cls.name==name).first()


class LocalRating(Base):
    __tablename__ = 'local_rating'
    id = Column(Integer, primary_key=True)
    local_id = Column(Integer, ForeignKey('local.id'),index=True)
    title = Column(Unicode(80))
    review = Column(UnicodeText)
    user_id = Column(Integer, ForeignKey('users.id'),index=True)
    created = Column(DateTime, default=func.now())
    modified = Column(DateTime, onupdate=func.now())
    user = relationship('Users', backref=backref('local_rating', cascade="all, delete-orphan"))
    feature_rating = relationship("LocalFeatureRating", backref="local_rating", cascade="all, delete, delete-orphan")

    @property
    def avg_rating(self):
        return round(sum(x.rating for x in self.feature_rating)/len(self.feature_rating)+0.0,1)

    @property
    def ratingByFeature(self):
        d = dict()
        for x in self.feature_rating:
            d.setdefault(x.feature.name,[]).append(x.rating)
        return d

class LocalFeatureRating(Base):
    """A table containing the user and the local & feature table id with rating"""
    __tablename__ = 'feature_rating'
    rating_id = Column(Integer, ForeignKey('local_rating.id'),primary_key=True)
    feature_id = Column(Integer, ForeignKey('feature_to_rate.id'), primary_key=True)
    rating = Column(Float)
    feature = relationship('FeatureToRate',backref="local_feature_rating")



class RecommendedFor(Base):
    __tablename__ = 'recommended_for'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(24))
    image = Column(Unicode(24))
    

class Schools(Content):
    __tablename__ = 'schools'
    id = Column(Integer,ForeignKey('content.id'), primary_key=True)
    local_id = Column(Integer, ForeignKey('local.id'),index=True)
    population = Column(Unicode(80))
    type_of_student = Column(Enum(u'Mixed',u'Only Girls',u'Only boys',name=u"type_of_student"))#mixed,only girls,only boys
    no_of_students = Column((Integer))
    no_of_teachers = Column(Integer)
    grade = Column(Enum(u'University',u'Polytechnic',u'College of education',u'Secondary school',u'Primary school',u'Nursery',name=u'grade'))
    mode_of_operation = Column(Enum(u'Only boarding', u'Only day', u'Both boarding and day', name=u"mode_of_operation"))
    ratings = relationship('SchoolRating', cascade="all, delete-orphan",backref="school")


class SchoolWebsites(Base):
    __tablename__ = "school_websites"
    id = Column(Integer, primary_key=True)
    school_id = Column(Integer, ForeignKey('schools.id'),index=True)
    school = relationship('Schools',backref=backref('websites', cascade="all, delete, delete-orphan"))
    url = Column(Unicode(80))
    title = Column(Unicode(80))
    

class SchoolRating(Base):
    __tablename__ = 'school_rating'
    id = Column(Integer, primary_key=True)
    school_id = Column(Integer, ForeignKey('schools.id'), index=True)
    rating = Column(Float)
    created = Column(DateTime, default=func.now)
    review = Column(UnicodeText)
    user_id = Column(Integer, ForeignKey('users.id'), index=True)
    user = relationship('Users', backref=backref('school_rating', cascade="all, delete-orphan"))

'''