from sqlalchemy import desc
from sqlalchemy import Table, Column
from sqlalchemy import ForeignKey
from sqlalchemy.orm import backref
from sqlalchemy.orm import relationship
from sqlalchemy.orm import joinedload
from sqlalchemy.types import Integer, Boolean
from sqlalchemy.types import Unicode
from sqlalchemy.types import UnicodeText
from sqlalchemy.types import DateTime
from sqlalchemy.sql import func
from webhelpers.paginate import PageURL_WebOb, Page
from webhelpers.date import time_ago_in_words 

from buddy.models import *
from buddy.models.resources import Content
from buddy.models.properties_model import State
import datetime
from pyramid.security import (ALL_PERMISSIONS,
                              Allow,
                              Authenticated
)

featured_blogs = Table('featured_blogs', Base.metadata,
    Column('featured_id', Integer, ForeignKey("featured_content.id")),
    Column('blog_id',Integer, ForeignKey("blogs.id"))
    )

blogs_categories = Table('blogs_categories',Base.metadata,
                         Column('blog_id', Integer, ForeignKey('blogs.id'), index=True),
                         Column('category_id',Integer,ForeignKey('blog_category.id')))
class BlogCategory(Base):
    """Blog type Entity"""
    __tablename__="blog_category"
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))
    description = Column(UnicodeText())
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("BlogCategory",
                        cascade="all",
                        backref=backref("parent", remote_side=id)
                    )

    def __init__(self, name,description='',parent=None):
        self.name = name
        self.parent = parent
        self.description =description

    @classmethod
    def get_by_id(cls,id):
        return DBSession.query(cls).filter(cls.id==id).first()

    @classmethod
    def get_by_name(cls,name):
        return DBSession.query(cls).filter(cls.name==name).first()

    @classmethod
    def all(cls):
        return DBSession.query(cls).filter(cls.parent==None).order_by(cls.name).all()

    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        return Page(cls.all(), page, url=page_url,
                    items_per_page=20)


class Blogs(Content):
    """Blog Entity"""
    __tablename__="blogs"
    id = Column(Integer, ForeignKey('content.id'), primary_key=True)
    comments = relationship("Comments", backref="blog", cascade="all, delete-orphan")
    categories = relationship('BlogCategory', secondary=blogs_categories, backref='blogs')
    pictures = relationship('Blog_Pictures',backref='blog', cascade="all, delete-orphan")
    state_id = Column(Integer, ForeignKey("state.id"),index=True)
    state = relationship(State, backref=backref("blogs", cascade="all, delete-orphan"))
    city = Column(Unicode(80))
    allow_comments = Column(Boolean, default=True)
    status = Column(Boolean, default=True)#draft and published
    __mapper_args__ = {'polymorphic_identity':'blog'}


    @classmethod
    def get_by_id(cls, blog_id):
        return DBSession.query(Blogs).filter(Blogs.id ==blog_id).first()
    
    @classmethod
    def all(cls, published=True):
        return DBSession.query(Blogs).filter(Blogs.status==published).\
    order_by(desc(Blogs.created)).all()
    
    @classmethod
    def get_query(cls, with_joinedload=True):
        query = DBSession.query(cls)
        if with_joinedload:
            query = query.options(joinedload('tags'), joinedload('users'))
        return query
    
    @classmethod
    def get_by_tagname(cls, tag_name, with_joinedload=True):
        query = cls.get_query(with_joinedload)
        return query.filter(Blogs.tags.any(name=tag_name))
        
    @classmethod
    def get_paginator(cls, request,page=1, published=True):
        page_url = PageURL_WebOb(request)
        return Page(Blogs.all(published), page, url=page_url,
                    items_per_page=12)


class Blog_Pictures(Base):

    __tablename__ = 'blog_pictures'
    id = Column(Integer, primary_key=True)
    blog_id = Column(Integer, ForeignKey('blogs.id'), index=True)
    filename = Column(Unicode(80))


class BlogFactory(Base):

    __tablename__ = 'blog_factory'
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
        blog = Blogs.get_by_name(key)
        if not blog:
            return
        blog.__parent__ = self
        blog.__name__ = key
        return blog


class Comments(Base):
    """Comment entity class"""
    __tablename__='comments'
    
    id = Column(Integer, primary_key=True)
    blog_id = Column(Integer, ForeignKey('blogs.id'))
    user_id = Column(Integer, ForeignKey('users.id'))
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("Comments",
                        cascade="all",
                        backref=backref("parent", remote_side=id)
                    )
    body = Column(UnicodeText)
    created = Column(DateTime, default=func.now())
    modified =Column(DateTime, onupdate=func.now())
    
    @property
    def timestamp(self):
        today = datetime.date.today()
        yesterday = today-datetime.timedelta(days=1)
        if self.created.date() == today:
            return time_ago_in_words(self.created,granularity="minute")+" ago"
        elif self.created.date()==yesterday:
            return self.created.strftime("yesterday at  %I:%M%p").lower()
        else:
            return self.created.strftime("%a %b %d, %Y")


    @property
    def __acl__(self):
        return [
            (Allow, self.user.id, 'edit'),
            (Allow, 'admin', 'edit')
        ]

    @classmethod
    def get_by_id(cls, com_id):
        return DBSession.query(cls).filter(Comments.id ==com_id).first()


class CommentFactory(Base):

    __tablename__ = 'comment_factory'
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
        comment = Comments.get_by_id(key)
        comment.__parent__ = self
        comment.__name__ = key
        return comment
    
class Reply(Base):
    __tablename__ = 'reply'
    id = Column(Integer, primary_key=True)
    comment_id = Column(Integer, ForeignKey('comments.id'))
    user_id = Column(Integer, ForeignKey('users.id'))
    
    body = Column(UnicodeText)
    created = Column(DateTime, default=func.now())
    modified =Column(DateTime, onupdate=func.now())
