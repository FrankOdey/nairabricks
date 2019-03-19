from webhelpers.html.tags import *
from webhelpers.text import *
from webhelpers.containers import *
from buddy.models import DBSession
from buddy.models.properties_model import PropertyCategory, Feature_types, State
from buddy.models.blogs_model import BlogCategory
from buddy.models.resources import Featured_Content

from buddy.models.user_model import User_types, Users, Subscription, Plans
from sqlalchemy import or_,and_
import random
naira= u'\u20a6'
from pyramid.renderers import render


def featured_professionals(request):
    #Find subscriptions that are either Silver or Gold
    subs = DBSession.query(Subscription).join(Plans).filter(Plans.name!="Basic").all()
    users = [i.user for i in subs if subs]
    if len(users)>0:
        users = [i for i in users if i.email!=u'info@nairabricks.com' and i.email!=u"splendidzigy24@gmail.com"]
        x = len(users)
        if x>4:
            x = 4
        users = random.sample(users,x)
        return render('buddy:templates/listing/sidebar/featured_pros.mako',dict(users=users),request=request)

def featured_listings(request, item):

    return render("buddy:templates/listing/featured_listings.mako",dict(item=item),
                  request=request)
def get_pcategories():
    p = DBSession.query(PropertyCategory).all()
    d=[]
    for category in p:
        if category.children:
            f=[(child.id, child.name) for child in category.children]
            f=f,category.name
            d.append(f)
    return d

def get_states():
    p = DBSession.query(State).all()
    d = [(a.id,a.name) for a in p ]
    return d

def get_property_features():
    p = DBSession.query(Feature_types).all()
    d=[]
    for feature in p:
        if feature.features:
            f=[(child.id, child.name) for child in feature.features]
            f=f,feature.name
            d.append(f)
    return d

def get_user_types():
    p = DBSession.query(User_types).all()
    d = [(child.id,child.name) for child in p]
    return d

def format_money(amount):
    stringNum = str(amount)
    length = len(stringNum)
    price=stringNum
    if length==4:
        price = stringNum[0]+','+stringNum[1:]
    if length==5:
        price = stringNum[0:2]+','+stringNum[2:]
    if length==6:
        price = stringNum[0:3]+','+stringNum[3:]
    if length==7:
        price = stringNum[0]+','+stringNum[1:4]+','+stringNum[4:]
    if length==8:
        price = stringNum[0:2]+','+stringNum[2:5]+','+stringNum[5:]
    if length==9:
        price = stringNum[0:3]+','+stringNum[3:6]+','+stringNum[6:]
    if length==10:
        price = stringNum[0]+','+stringNum[1:4]+','+stringNum[4:7]+','\
                +stringNum[7:]
    return u'\u20a6 ' +price