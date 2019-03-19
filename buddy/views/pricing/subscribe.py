from buddy.models import DBSession
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound, HTTPNotFound
from pyramid.response import Response
from datetime import datetime, timedelta

from buddy.models.resources import Featured_Content
from buddy.models.user_model import Subscription, Users
from buddy.views.messages import buddy_settings
from buddy.views.schema import PlanSchema, PaymentSchema, PromoSubSchema
from ...models.user_model import Plans
import requests
from paystackapi.paystack import Paystack
__author__ = 'ephraim'


@view_config(route_name="pricing", renderer="buddy:templates/pricing/index.mako")
def plans(request):
    plans = DBSession.query(Plans).order_by(Plans.id).all()
    return dict(title="Pricing",plans=plans)


@view_config(route_name="list_plans",renderer="buddy:templates/pricing/listplans.mako")
def listplans(request):
    plans = DBSession.query(Plans).order_by(Plans.id).all()
    form  = Form(request, schema=PlanSchema())
    if 'form_submitted' in request.POST and form.validate():
        plan = form.bind(Plans())
        DBSession.add(plan)
        DBSession.flush()
        return HTTPFound(location=request.route_url('list_plans'))
    return dict(form = FormRenderer(form), plans=plans, title="List of plans")


@view_config(route_name="edit_plan",renderer="buddy:templates/pricing/editplans.mako")
def editplans(request):
    pid = request.matchdict.get('id')
    plan = DBSession.query(Plans).get(pid)
    form  = Form(request, schema=PlanSchema(), obj=plan)
    if 'form_submitted' in request.POST and form.validate():
        form.bind(plan)
        DBSession.add(plan)
        DBSession.flush()
        return HTTPFound(location=request.route_url('list_plans'))
    return dict(form = FormRenderer(form), plan=plan, title=plan.name+" Edit")


@view_config(route_name="subscribe_plan", renderer="buddy:templates/pricing/subscribe.mako", permission="post")
def subscribe_plan(request):
    name = request.matchdict['name']
    type = request.matchdict['type']
    plan = DBSession.query(Plans).filter(Plans.name==name).first()
    title = plan.name+ " Plan subscription"

    form = Form(request, schema=PaymentSchema)
    if 'submit' in request.POST and form.validate():
        duration = form.data['duration']
        amount = duration * plan.price_per_month
        discount_percent = "-"
        if 5 < duration < 12:
            # total amount to pay
            total = duration * plan.price_per_month
            # 5% discount since it is more than 5 and less than 12
            discount = total * 0.05
            # resultant amount to pay is now:
            amount = total - discount
            discount_percent = u"5%"
        elif duration == 12:
            # total amount to pay
            total = duration * plan.price_per_month
            # 10% discount since it is 12 months
            discount = total * 0.1
            # resultant amount to pay is now:
            amount = total - discount
            discount_percent = u"10%"
        paystack_secret_key = buddy_settings("paystack_secret_key")
        paystack = Paystack(secret_key=paystack_secret_key)
        #Renew
        if type=="Renew":
            # get active subscription
            # set it to Expired. set the expiration date to today
            # set new subscription expiration date to old active subscription expiration date + one month +2days
            active_sub = request.user.active_subscription[0]
            subscription = Subscription(
                user=request.user,
                plan=plan,
                amount=amount,
                no_of_months=duration,
                discount=discount_percent,
                start_date=datetime.today()
            )
            DBSession.add(subscription)
            subscription.end_date = active_sub.end_date+ timedelta(days=duration * 30+2)
            active_sub.status = u"Expired"
        else:
            subscription = Subscription(
                user=request.user,
                plan=plan,
                amount=amount,
                no_of_months=duration,
                discount=discount_percent,
                start_date=datetime.today(),
                end_date=datetime.today() + timedelta(days=duration * 30)
            )
            DBSession.add(subscription)

        DBSession.flush()
        callback_url = request.route_url('subscription_success',reference=subscription.reference)
        try:
            response = paystack.transaction.initialize(email=request.user.email,callback_url=callback_url,
                                                   amount=str(int(amount)) + "00", reference=subscription.reference)
        except requests.exceptions.ConnectionError:
            request.session.flash('info; Not enough Network')
            return HTTPFound(location=request.route_url('pricing'))
        if response['status']:
            authorization_url = response['data']['authorization_url']
            return Response(status_int=302, location=authorization_url)
    return dict(form=FormRenderer(form),title=title, plan=plan, type=type)


@view_config(route_name="subscription_success", renderer = "buddy:templates/pricing/success.mako")
def subscription_success(request):
    reference = request.matchdict['reference']
    sub = DBSession.query(Subscription).filter_by(reference=reference).first()
    if not sub:
        return HTTPNotFound()
    paystack_secret_key = buddy_settings("paystack_secret_key")
    paystack = Paystack(secret_key=paystack_secret_key)
    response = paystack.transaction.verify(reference)
    if response['status']:
        success = response['data']['status']
        if success:
            if not sub.status == u'Active':
                sub.status = u'Active'
            pass
        else:
            sub.status = u'Failed'
    return dict(sub=sub, title="Payment Successful")


@view_config(route_name="my_subscription", renderer="buddy:templates/pricing/my_subscription.mako")
def my_sub(request):
    user = request.user
    plan=None
    active_sub = None
    total_premium_listings = 0
    total_premium_blogs = 0
    if user.active_subscription:
        plan = user.active_subscription[0].plan
        active_sub = user.active_subscription[0]
    subscriptions = DBSession.query(Subscription).filter_by(user=user).order_by(Subscription.id.desc()).all()
    premium = DBSession.query(Featured_Content).filter(Featured_Content.name == 'Premium').first()
    if premium:
        premium_lis = premium.featured_properties
        if premium_lis:
            for item in premium_lis:
                if item.user == user:
                    total_premium_listings += 1
        premium_blogs = premium.featured_blogs
        if premium_blogs:
            for item in premium_blogs:
                if item.user == user:
                    total_premium_blogs += 1
    return dict(title="My subscriptions",total_premium_listings=total_premium_listings,
                total_premium_blogs=total_premium_blogs,
                user=user, subscriptions=subscriptions, plan=plan, active_sub=active_sub)


@view_config(route_name="promo_sub", permission="superadmin")
def promo_sub(request):
    id = request.matchdict['id']
    user = Users.get_by_id(id)
    if not user:
        return HTTPNotFound()
    form = Form(request, schema=PromoSubSchema)
    if 'submit' in request.POST and form.validate():
        plan_id = form.data['plan']
        plan  = DBSession.query(Plans).get(plan_id)
        if plan:
            subscription = Subscription(
                user=user,
                plan=plan,
                amount=0,
                no_of_months=1,
                discount="100%",
                status = "Active",
                start_date=datetime.today(),
                end_date=datetime.today() + timedelta(days=30)
            )
            DBSession.add(subscription)
            DBSession.flush()
            if request.is_xhr:
                html = """<div class="alert alert-success alert-dismissable col-xs-12">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            User subscription
                            </div>"""
                return Response(html)
            request.session.flash('success; User subscribed')
            return HTTPFound(location=request.route_url('profile', prefix=user.prefix))
        if request.is_xhr:
            html = """<div class="alert alert-danger alert-dismissable col-xs-12">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        An error occured, user Not subscribed
                        </div>"""
            return Response(html)
        request.session.flash('danger; An error occured, user subscribed %s'%form.all_errors())
        return HTTPFound(location=request.route_url('profile', prefix=user.prefix))
    if request.is_xhr:
        html = """<div class="alert alert-danger alert-dismissable col-xs-12">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    An error occured, user Not subscribed
                    </div>"""
        return Response(html)
    request.session.flash('danger; An error occured, user subscribed %s'%form.all_errors())
    return HTTPFound(location=request.route_url('profile', prefix=user.prefix))