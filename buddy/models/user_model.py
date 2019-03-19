from sqlalchemy import Table
from sqlalchemy import Column
from sqlalchemy import ForeignKey, Index, Enum
from sqlalchemy.orm import backref
from sqlalchemy.orm import relationship, column_property
from sqlalchemy.orm import synonym
from sqlalchemy.types import Integer, Float
from sqlalchemy.types import Unicode,UnicodeText, Boolean
from sqlalchemy.types import DateTime
from sqlalchemy.sql import func
import cryptacular.bcrypt
from buddy.models import Base, DBSession
from buddy.models.blogs_model import Comments
from pyramid.security import ALL_PERMISSIONS, Allow,Everyone,Authenticated
from buddy.models.properties_model import State
from buddy.models.resources import Content
crypt = cryptacular.bcrypt.BCRYPTPasswordManager()
import datetime, random
from webhelpers.date import time_ago_in_words


alphabet = u'NB-'
NUMBER = u'123456789'
ALPHABET = u'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

def make_random_string(length,string):
    'Return a random number(number) of a given length'
    return ''.join(random.choice(string) for n in xrange(length))

def make_random_unique_number(length, is_unique, source):
    """Generates a random string

    :param length: is the length of expected output
    :param is_unique: a function that checks that generated string is unique
    :param source: string to generate from
    :return: random string of given length
    """
    # Initialize
    iterationCount = 0
    permutationCount = len(NUMBER) ** length
    while iterationCount < permutationCount:
        # Make randomID
        randomID = alphabet + make_random_string(length,source)
        iterationCount += 1
        # If our randomID is unique, return it
        if is_unique(randomID):
            return randomID
    # Raise exception if we have no more permutations left
    raise RuntimeError('Could not create a unique string')


def is_unique(serial):
    reg = DBSession.query(Users).filter(Users.serial==serial).first()
    if reg:
        return False
    return True


def is_unique_ref(serial):
    ref = DBSession.query(Subscription).filter(Subscription.reference==serial).first()
    if ref:
        return False
    return True


def hash_password(password):
    return unicode(crypt.encode(password))


def get_user(request):
    user_id = request.unauthenticated_userid
    if user_id is not None:
        return Users.get_by_id(user_id)
    return None


class User_types(Base):
    """User type entity class"""
    __tablename__ = 'user_types'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(80))

    def __init__(self, name=""):
        self.name = name

    users = relationship('Users', cascade="all, delete-orphan",
                         backref = 'user_type')

user_group = Table('user_group', Base.metadata,
    Column('user_id', Integer, ForeignKey("users.id", onupdate='CASCADE', ondelete='CASCADE')),
    Column('group_id',Integer, ForeignKey("groups.id", onupdate='CASCADE', ondelete='CASCADE')))


# need to create Unique index on (user_id,group_id)
##Index('user_group', user_group.c.user_id, user_group.c.group_id)


class Groups(Base):
    """ Table name: auth_groups

::

    id = Column(types.Integer(), primary_key=True)
    name = Column(Unicode(80), unique=True, nullable=False)
    description = Column(Unicode(255), default=u'')
    """
    __tablename__ = 'groups'

    id = Column(Integer(), primary_key=True)
    name = Column(Unicode(80), unique=True, nullable=False)
    description = Column(Unicode(255), default=u'')

    users = relationship('Users', secondary=user_group,
                     backref='mygroups')

    def __repr__(self):
        return u'%s' % self.name

    def __unicode__(self):
        return self.name

user_favourites = Table('user_favourites', Base.metadata,
    Column('user_id', Integer, ForeignKey("users.id")),
    Column('listing_id',Integer, ForeignKey("listings.id"))
    )


class Users(Base):
    """ User Entity class"""
    __tablename__ = 'users'

    id = Column(Integer, primary_key = True)
    serial = Column(Unicode(80),default=lambda:make_random_unique_number(4,is_unique,NUMBER))
    firstname = Column(Unicode(80))
    surname = Column(Unicode(80))
    fullname = column_property(firstname + " " + surname)
    prefix = Column(Unicode(120))
    email = Column(Unicode(80), unique=True, index=True)
    email_verified = Column(Boolean, default=False)
    _password = Column(Unicode(80))
    is_verified = Column(Boolean, default=False)
    state_id = Column(Integer, ForeignKey('state.id'))
    state = relationship(State, backref=backref('users', cascade="all, delete-orphan"))
    city = Column(Unicode(100))
    comments = relationship(Comments, lazy="dynamic",cascade="all, delete-orphan", backref="user")
    ##delivered_hits = Column(Integer, default=0)
    join_date = Column(DateTime, default=func.now())
    headline = Column(Unicode(255))
    note = Column(UnicodeText)
    photo = Column(Unicode(100))
    thumbnail = Column(Unicode(100))
    cover_photo = Column(Unicode(100))
    company_name = Column(Unicode(80))
    company_logo = Column(Unicode(80))
    address = Column(Unicode(80))
    mobile = Column(Unicode(80))
    phone = Column(Unicode(80))
    favourites = relationship("Listings",secondary='user_favourites',
                              backref='my_favourites')
    is_pro = Column(Boolean, default=False)
    user_type_id = Column(Integer, ForeignKey('user_types.id'))
    total_visits = Column(Integer, default=1)
    fb = Column(Unicode(80))
    tw = Column(Unicode(80))
    linkedin = Column(Unicode(80))
    parent_id = Column(Integer, ForeignKey(id))
    children = relationship("Users",
                            cascade="all",
                            backref=backref("parent", remote_side=id)
                            )
    balance = Column(Integer, default=0)
    earned_benefit =Column(Boolean, default=0)

    @property
    def profile_percentage(self):
        percentage = 10
        if self.photo:
            percentage += 10
        if self.company_logo:
            percentage += 10
        if self.headline:
            percentage += 20
        if self.content.filter_by(type = 'listing').count():
            percentage += 20
        if self.content.filter_by(type = 'answer').count():
            percentage += 10
        if self.content.filter_by(type = 'blog').count():
            percentage +=10
        if self.note:
            percentage += 10
        return percentage

    @property
    def __acl__(self):
        return [
            (Allow, self.id, 'edit'),
            (Allow, 'admin', 'edit')
        ]

    def _get_password(self):
        return self._password

    def _set_password(self, password):
        self._password = hash_password(password)

    password = property(_get_password, _set_password)
    password = synonym('_password', descriptor=password)

    @classmethod
    def check_password(cls, email, password):
        user= cls.get_by_email(email)
        if not user:
            return False
        return crypt.check(user.password, password)

    @classmethod
    def get_by_id(cls, user_id):

        return DBSession.query(cls).filter(cls.id==user_id).first()


    @property
    def total_unseen_messages(self):
        t=0
        if self.messages:
            for message in self.messages:
                if not message.is_seen:
                    t+=1
        return t

    @classmethod
    def get_by_path(cls, path):
        return DBSession.query(cls).filter(cls.prefix==path).first()

    @classmethod
    def get_by_email(cls, email):
        return DBSession.query(cls).filter(cls.email == email).first()


    @property
    def user_rating(self):
        if self.rating:
            return round(sum(x.rating for x in self.rating)/(len(self.rating)+0.0),1)
        return ''
    @property
    def user_fullname(self):
        return self.firstname+" "+self.surname

    @property
    def active_subscription(self):
        sub = [i for i in self.subscription if i.status=='Active']
        if len(sub)>0:
            return sub
        return None
    @property
    def total_listings(self):
        return self.content.filter_by(type='listing').count()

    @property
    def total_blogs(self):
        return self.content.filter_by(type='blog').count()



class AuthUserLog(Base):
    """
    event:
      L - Login
      R - Register
      P - Password
      F - Forgot
    """
    __tablename__ = 'auth_user_log'
    __table_args__ = {'sqlite_autoincrement': True}

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey(Users.id), index=True)
    user = relationship(Users,backref=backref('user_log',cascade='all, delete-orphan'))
    time = Column(DateTime(), default=func.now())
    ip_addr = Column(Unicode(39), nullable=False)
    event = Column(Enum(u'L',u'R',u'P',u'F', name=u'event'), default=u'L')

    @property
    def timestamp(self):
        today = datetime.date.today()
        yesterday = today-datetime.timedelta(days=1)
        if self.time.date() == today:
            return time_ago_in_words(self.time,granularity="minute")+" ago"
        elif self.time.date()==yesterday:
            return self.time.strftime("yesterday at  %I:%M%p").lower()
        else:
            return self.time.strftime("%a %b %d, %Y")


class Messages(Base):
    __tablename__ = 'messages'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    user = relationship('Users',backref=backref('messages', cascade="all, delete, delete-orphan"),
                        foreign_keys=[user_id])
    url = Column(Unicode(80))
    type = Column(Unicode(50))
    title = Column(Unicode(80))
    body = Column(UnicodeText)
    is_read = Column(Boolean, default=False)
    is_seen = Column(Boolean, default=False)
    created = Column(DateTime, default=func.now())


    @property
    def timestamp(self):
        today = datetime.date.today()
        yesterday = today-datetime.timedelta(days=1)
        if self.created.date() == today:
            return time_ago_in_words(self.created,granularity="minute")+" ago"
        elif self.created.date()==yesterday:
            return self.created.strftime("Yesterday at  %I:%M%p").lower()
        else:
            return self.created.strftime("%a %b %d, %Y")

    @classmethod
    def get_by_id(cls,id):
        return DBSession.query(cls).get(id)

class UserWebsites(Base):
    __tablename__ = 'user_website'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), index=True)
    user = relationship('Users', backref=backref('websites', cascade="all, delete, delete-orphan"))
    title = Column(Unicode(100))
    url = Column(Unicode(255))


class UserRating(Base):
    __tablename__ = 'user_rating'
    id = Column(Integer, primary_key=True)
    rating = Column(Float)
    rated_id = Column(Integer, ForeignKey('users.id'), index=True)
    rater_id = Column(Integer, ForeignKey('users.id'), index=True)
    rated_user = relationship('Users', backref=backref('rating', cascade="all, delete-orphan"), foreign_keys=[rated_id])
    rater = relationship('Users', backref=backref('rates', cascade = 'all, delete,delete-orphan'), foreign_keys=[rater_id])
    review = Column(Unicode(255))

class EmailBank(Base):
    __tablename__ = 'emailbank'
    id = Column(Integer, primary_key=True)
    address = Column(Unicode(80))


def groupfinder(userid,request):
    user = request.user
    if user is not None:
        return [g.name for g in user.mygroups]
    return None

class Plans(Base):
    __tablename__ = 'plans'
    id = Column(Integer, primary_key=True)
    code = Column(Unicode(50))
    name = Column(Unicode(50))
    price_per_month = Column(Float)
    max_listings = Column(Integer)
    max_premium_listings = Column(Integer)
    max_blogposts = Column(Integer)
    max_premium_blogposts = Column(Integer)
    featured_profile = Column(Boolean)


class Subscription(Base):
    __tablename__ = 'subscription'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), index=True)
    user = relationship('Users', backref=backref('subscription', cascade="all, delete-orphan"))
    plan_id = Column(Integer, ForeignKey('plans.id'), index=True)
    plan = relationship('Plans', backref=backref('Plans', cascade="all, delete-orphan"))
    amount = Column(Float)
    no_of_months = Column(Integer)
    discount = Column(Unicode(50))
    start_date = Column(DateTime)
    end_date = Column(DateTime)
    reference = Column(Unicode(100),default=lambda:make_random_unique_number(9, is_unique_ref, ALPHABET))
    status = Column(Enum("Pending", "Failed", "Active", "Expired", name="status"),default="Pending")


class UserFactory(Base):

    __tablename__ = 'user_factory'
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
        user = Users.get_by_path(key)
        if not user:
            return
        user.__parent__ = self
        user.__name__ = key
        return user





def init_model(engine):
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)