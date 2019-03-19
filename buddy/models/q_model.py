from sqlalchemy import Table, desc
from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy.orm import backref
from sqlalchemy.orm import relationship
from sqlalchemy.orm import column_property
from sqlalchemy.types import Integer
from sqlalchemy.types import Boolean
from sqlalchemy.types import Unicode
from sqlalchemy.types import UnicodeText
from sqlalchemy.types import DateTime
from sqlalchemy.sql import func
from webhelpers.paginate import PageURL_WebOb, Page

from webhelpers.html import literal
from webhelpers.text import truncate
from webhelpers.html.tools import strip_tags
from buddy.models import *
from buddy.models.resources import Content
from buddy.utils.url_normalizer import url_normalizer

from buddy.models.user_model import Users
from buddy.models.properties_model import State
from pyramid.security import (ALL_PERMISSIONS, Allow, Everyone, Authenticated)

q_categories_mm = Table('quest_categories',Base.metadata,
                         Column('q_id', Integer, ForeignKey('questions.id'), index=True),
                         Column('category_id',Integer,ForeignKey('q_category.id')))

class QCategory(Base):
    """Question Category Entity Model"""
    __tablename__ = 'q_category'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80), nullable=False)
    description = Column(UnicodeText())
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("QCategory", cascade="all", backref=backref("parent", remote_side=id))


    def __init__(self, name,description='', parent=None):
        self.name = name
        self.parent = parent
        self.description = description

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

'''
q_voted_users = Table('q_votes', Base.metadata, Column('q_id', Integer, ForeignKey('questions.id')),
                    Column('user_id', Integer, ForeignKey('users.id'))
)
'''

class Questions(Content):
    """Question Entity"""
    __tablename__ = "questions"
    id = Column(Integer, ForeignKey('content.id'), primary_key=True)
    categories = relationship('QCategory', secondary=q_categories_mm, backref='questions')
    state_id = Column(Integer, ForeignKey("state.id"),index=True)
    state = relationship(State, backref=backref("questions", cascade="all, delete-orphan"))
    city = Column(Unicode(80))
    anonymous = Column(Boolean, default=False)
    '''
    up = Column(Integer, default=0)
    down = Column(Integer, default=0)
    voted_users = relationship(Users, secondary=q_voted_users,
                               backref='voted_questions')
    vote_percent = func.coalesce(up / (up + down) * 100, 0)
    vote_percentage = column_property(vote_percent)

    total_votes = column_property((up + down))

    vote_differential = column_property((up - down))
    def user_voted(self, username):
        return bool(self.voted_users.filter_by(fullname=username).first())

    def vote(self, user, positive):
        if positive:
            self.up += 1
            self.user.up += 1
            user.delivered_hits += 1
        else:
            self.down += 1
            self.user.down += 1
            user.delivered_misses += 1

        self.voted_users.append(user)
    '''

    __mapper_args__ = {'polymorphic_identity': 'question'}



    @classmethod
    def get_by_id(cls, q_id):
        return DBSession.query(Questions).filter(Questions.id ==q_id).first()

    @classmethod
    def all(cls):
        return DBSession.query(Questions).order_by(desc(Questions.created))

    @property
    def excerpt(self):
        result = truncate(strip_tags(literal(self.body)), length=200, whole_word=True)

        return result


    @classmethod
    def get_paginator(cls, request,page=1):
        page_url = PageURL_WebOb(request)
        return Page(Questions.all(), page, url=page_url,
                    items_per_page=10)



class QuestionFactory(Base):
    __tablename__ ='question_factory'
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
        q = Questions.get_by_name(key)
        if not q:
            return
        q.__parent__ = self
        q.__name__ = key
        return q


a_voted_users = Table('answers_votes', Base.metadata,
    Column('answer_id', Integer, ForeignKey('answers.id')),
    Column('user_id', Integer, ForeignKey('users.id'))
)


class Answers(Content):
    """Answer entity class"""
    __tablename__='answers'

    id = Column(Integer, ForeignKey('content.id'), primary_key=True)
    q_id = Column(Integer, ForeignKey('questions.id'),index=True)
    question = relationship("Questions", backref =backref("answers", cascade="all,delete, delete-orphan"), foreign_keys=[q_id])
    anonymous = Column(Boolean, default=False)
    up = Column(Integer, default=0)
    down = Column(Integer, default=0)
    voted_users = relationship('Users', secondary=a_voted_users,backref='voted_answers')
    vote_percent = func.coalesce(up / (up + down) * 100, 0)

    vote_percentage = column_property(vote_percent)

    total_votes = column_property((up + down))

    vote_differential = column_property((up - down))
    __mapper_args__ = {'polymorphic_identity': 'answer'}


    def user_voted(self, id):
        return bool(self.voted_users.filter_by(id=id).first())





class AnswerFactory(Base):
    __tablename__ ='answer_factory'
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
        a = Answers.get_by_name(key)
        a.__parent__ = self
        a.__name__ = key
        return a