#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'


def pricing(config):
    config.add_route('pricing', '/pricing')
    config.add_route('list_plans', '/p/dashboard/plans')
    config.add_route('edit_plan', '/p/dashboard/{id}/edit')
    config.add_route('subscribe_plan', '/plans/subscribe/{name}/{type}')
    config.add_route('subscription_success', '/subscribe-success/{reference}')
    config.add_route('my_subscription', '/my-subscription')
    config.add_route('promo_sub', 'promosubscription/{id}')
