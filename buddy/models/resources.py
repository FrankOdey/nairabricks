from sqlalchemy import Table
from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy.types import Integer, Boolean
from sqlalchemy.types import Unicode
from sqlalchemy.types import UnicodeText
from sqlalchemy.types import DateTime
from sqlalchemy.types import String
from sqlalchemy.sql import func
from sqlalchemy.orm import backref
from sqlalchemy.orm import relationship
from webhelpers.paginate import PageURL_WebOb, Page
from webhelpers.date import time_ago_in_words
from webhelpers.html import literal
from webhelpers.text import truncate
from webhelpers.html.tools import strip_tags
import datetime
from buddy.models import *

from pyramid.security import Allow, ALL_PERMISSIONS, Authenticated, Everyone


'''
class Tags(Base):
    """
    Content's tag model.
    """
    __tablename__ = 'tags'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80), unique=True, index=True)

    def __init__(self, name):
        self.name = name
        
    @staticmethod
    def extract_tags(tags_string):
        
        tags = [tag.title() for tag in tags_string.split(',')]
        
        tags = set(tags)

        return tags

    @classmethod
    def get_by_name(cls, tag_name):
        tag = DBSession.query(cls).filter(cls.name == tag_name)
        return tag.first()

    @classmethod
    def get_by_id(cls, id):
        tag = DBSession.query(cls).filter(cls.id == id)
        return tag.first()

    @classmethod
    def create_tags(cls, tags_string):
        tags_list = cls.extract_tags(tags_string)
        tags = []
        for tag_name in tags_list:
            tag = cls.get_by_name(tag_name)
            if not tag:
                tag = Tags(name=tag_name)
                DBSession.add(tag)
            tags.append(tag)
        return tags

    @classmethod
    def tag_counts(cls):
        query = DBSession.query(Tags.name, func.count('*'))
        return query.join('content').group_by(Tags.name)

    @classmethod
    def all(cls):
        return DBSession.query(Tags).\
    order_by(Tags.name)
    
    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        return Page(Tags.all(), page, url=page_url,
                    items_per_page=10)


TagsToDocument = Table('tags_to_document', Base.metadata,
    Column('tag_id', Integer, ForeignKey('tags.id')),
    Column('document_id', Integer, ForeignKey('document.id'))
)
'''
class Featured_Content(Base):
    __tablename__ = 'featured_content'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    featured_properties = relationship("Listings",secondary='featured_properties',
                              backref='featured')
    featured_blogs = relationship("Blogs", secondary='featured_blogs',
                                       backref='featured')
class Content_Stat(Base):
    __tablename__ = "content_stat"
    id = Column(Integer, primary_key=True)
    content_id = Column(Integer, ForeignKey('content.id'))
    content = relationship("Content",backref=backref('stat',cascade="all,delete-orphan"))
    views = Column(Integer)
    date = Column(DateTime,default=func.now())

class Content(Base):
    """Content object"""
    __tablename__ = "content"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), index=True)
    user = relationship("Users",backref=backref('content', lazy="dynamic",cascade="all,delete-orphan"))
    name = Column(Unicode(255),unique=True, nullable=False)
    title = Column(Unicode(255))
    body = Column(UnicodeText)
    created = Column(DateTime, default=func.now())
    modified = Column(DateTime, onupdate=func.now())
    type = Column(String(20))
    total_views =Column(Integer, default=0)
    total_likes = Column(Integer)
    hidden = Column(Boolean, default=False)

    __mapper_args__ = {
        'polymorphic_on':type,
        'polymorphic_identity':'content',
        'with_polymorphic':'*'
    }
    @property
    def total_view(self):
        t = DBSession.query(Content_Stat).filter(Content_Stat.content_id==self.id).count()
        return t

    @classmethod
    def get_by_name(cls, name):
        return DBSession.query(cls).filter_by(name=name).first()

    @property
    def excerpt(self):
        result= truncate(strip_tags(literal(self.body)),length=300, whole_word=True)

        return result

    @property
    def timestamp(self):
        today = datetime.date.today()+datetime.timedelta(hours=1)
        yesterday = today-datetime.timedelta(days=1)
        if self.created.date() == today:
            return time_ago_in_words(self.created+datetime.timedelta(hours=1),granularity="minute")+" ago"
        elif self.created.date()==yesterday:
            return (self.created+datetime.timedelta(hours=1)).strftime("Yesterday at  %I:%M%p").lower()
        else:
            return (self.created+datetime.timedelta(hours=1)).strftime("%a %b %d, %Y")

    @property
    def modified_timestamp(self):
        today = datetime.date.today()
        yesterday = today-datetime.timedelta(days=1)
        if self.modified.date() == today:
            return time_ago_in_words(self.modified,granularity="minute")+" ago"
        elif self.modified.date()==yesterday:
            return self.modified.strftime("Yesterday at  %I:%M%p").lower()
        else:
            return self.modified.strftime("%a %b %d, %Y")
    @property
    def __acl__(self):
        return [
            (Allow, self.user.id, 'edit'),
            (Allow, 'admin', 'edit')]

class Document(Content):
    __tablename__ = "document"
    id = Column(Integer, ForeignKey('content.id'),primary_key=True)
    __mapper_args__ = {'polymorphic_identity':'document'}

    @classmethod
    def get_by_id(cls,id):
        return DBSession.query(Document).filter(Document.id==id).first()

'''
class DocFactory(Base):

    __tablename__ = 'doc_factory'
    id = Column(Integer, primary_key=True)
    __acl__ = [
                (Allow, Authenticated, 'post'),
                (Allow,'superadmin',ALL_PERMISSIONS),
                (Allow, 'admin',('admin','supermod','mod','edit')),
                (Allow, 'supermod',('supermod','mod')),
                (Allow, 'mod','mod')
    ]

    def __init__(self, request):
        if request.matchdict:
            self.__dict__.update(request.matchdict)

    def __getitem__(self, key):
        doc = Document.get_by_name(key)
        doc.__parent__ = self
        doc.__name__ = key
        return doc


class File(Base):
    """This is necessary for uploading files/images to the site"""
    __tablename__ = "file"
    id = Column(Integer, primary_key=True)
    description = Column(Unicode(255))
    filename = Column(Unicode(100))
'''

class FrontPix(Base):
    """This is necessary for uploading files/images to the site"""
    __tablename__ = "frontpix"
    id = Column(Integer,primary_key=True)
    filename = Column(Unicode(100))


class RootFactory(Base):
    """ Defines the ACLs,
    """
    __tablename__='root'
    id = Column(Integer, primary_key=True)
    def __init__(self, request):
        if request.matchdict:
            self.__dict__.update(request.matchdict)

    @property
    def __acl__(self):

        defaultlist = [(Allow, Authenticated, 'post'),
            (Allow, 'superadmin', ALL_PERMISSIONS),
            (Allow, 'admin',('admin','supermod','mod','edit')),
            (Allow, 'supermod',('supermod','mod')),
            (Allow, 'mod','mod')
        ]

        return defaultlist

