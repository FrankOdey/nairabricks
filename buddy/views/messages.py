#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'ephraim'
from pyramid_mailer import get_mailer
from pyramid_mailer.message import Message
from pyramid.url import route_url
from pyramid.settings import asbool
from pyramid.util import DottedNameResolver
from buddy.models.user_model import AuthUserLog
from buddy.models import DBSession
from pyramid.threadlocal import get_current_registry
from pyramid.security import remember
import transaction



class EmailMessageText(object):
    """ Default email message text class
    """

    def forgot(self):
        """
In the message body, %_url_% is replaced with:

::

    route_url('apex_reset', request, user_id=user_id, hmac=hmac))
        """
        return {
                'subject': 'Password reset request received',
                'body': """
                <!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Password reset request received.</title>
    </head>
    <body>
<p>A request to reset your password has been received. Please go to
the following URL to change your password:</p><br>

%_url_%

<p>If you did not make this request, you can safely ignore it.</p>
</body>
</html>
"""
        }

    def activate(self):
        """
In the message body, %_url_% is replaced with:

::

    route_url('apex_activate', request, user_id=user_id, hmac=hmac))
        """
        return {
                'subject': 'Account activation. Please activate your account.',
                'body': """
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Account activation. Please activate your account.</title>
    </head>
    <body>
<p>This site requires account activation. Please follow the link below to
activate your account:</p>

<a href='%_url_%'>activate</a>

<p>If the link is not opening, copy the link below and paste it in your browser:</p>

<a href='%_url_%'>%_url_%</a>

<p>However, If you did not make this request, you can safely ignore it.</p>

<p>Nairabricks Registration Team</a>
</body>
</html>
"""
        }


def html_email_sender(request, recipients,subject,body,sender=None,extra_headers=None):
    """Generic html email sender"""
    mailer = get_mailer(request)
    if not sender:
        sender = 'no-reply@nairabricks.com'
    message = Message(subject=subject,
                      sender=sender,
                      recipients=[recipients],
                      html=body,extra_headers=extra_headers)
    mailer.send(message)

def non_html_email_sender(request, recipients,subject,body,sender=None,extra_headers=None):
    """Generic Non html email sender"""
    mailer = get_mailer(request)
    if not sender:
        sender = 'no-reply@nairabricks.com'
    message = Message(subject=subject,
                      sender=sender,
                      recipients=[recipients],
                      body=body,extra_headers=extra_headers)
    mailer.send(message)

def send_email(request, recipients, subject, body, sender=None):
    """ Sends email message
    """
    mailer = get_mailer(request)
    if not sender:
        sender = 'no-reply@nairabricks.com'
    message = Message(subject=subject,
                      sender=sender,
                      recipients=[recipients],
                      html=body)
    mailer.send(message)

    report_recipients = 'Nairabricks <info@nairabricks.com>'
    if not report_recipients:
        return

    report_recipients = [s.strip() for s in report_recipients.split(',')]

    # since the config options are interpreted (not raw)
    # the report_subject variable is not easily customizable.
    report_subject = "Registration activity for '%(recipients)s' : %(subject)s"

    report_prefix = 'Attention:'
    if report_prefix:
        report_subject = report_prefix + ' ' + report_subject

    d = { 'recipients': recipients, 'subject': subject }
    report_subject = report_subject % d

    body = "The following registration-related activity occurred: \r\n" + \
        "--------------------------------------------\r\n" + body
    message = Message(subject=report_subject,
                      sender=sender,
                      recipients=report_recipients,
                      html=body)
    mailer.send(message)



def email_forgot(request, user_id, email, hmac):

    message_class = EmailMessageText()
    message_text = getattr(message_class, 'forgot')()

    message_body = message_text['body'].replace('%_url_%',
        route_url('reset_password', request, user_id=user_id, hmac=hmac))

    html_email_sender(request, email, message_text['subject'], message_body)


def confirm_email(request, user_id, email, hmac):
    message_class = EmailMessageText()
    message_text = getattr(message_class,'activate')()
    message_body = message_text['body'].replace('%_url_%',
        route_url('email_activate',request,user_id=user_id,hmac=hmac))
    html_email_sender(request, email, message_text['subject'], message_body)

def user_regmail(request, user_id, email, hmac):
    message_class = EmailMessageText()
    message_text = getattr(message_class,'activate')()
    message_body = message_text['body'].replace('%_url_%',
        route_url('email_activate',request,user_id=user_id,hmac=hmac))
    send_email(request, email, message_text['subject'], message_body)


def buddy_settings(key=None, default=None):
    """ Gets a buddy setting if the key is set.
        If no key is set, returns all the buddy settings.

        Some settings have issue with a Nonetype value error,
        you can set the default to fix this issue.
    """
    settings = get_current_registry().settings

    if key:
        return settings.get('buddy.%s' % key, default)
    else:
        buddy_settings = []
        for k, v in settings.items():
            if k.startswith('buddy.'):
                buddy_settings.append({k.split('.')[1]: v})
        return buddy_settings




def get_module(package):
    """ Returns a module based on the string passed
    """
    resolver = DottedNameResolver(package.split('.', 1)[0])
    return resolver.resolve(package)


def buddy_remember(request, user, event='L'):
    if asbool(buddy_settings('log_logins')):
        if buddy_settings('log_login_header'):
            ip_addr = request.environ.get(buddy_settings('log_login_header'),
                                          u'invalid value - buddy.log_login_header')
        else:
            ip_addr = unicode(request.environ['REMOTE_ADDR'])
        record = AuthUserLog(user_id=user.id,
                             ip_addr=ip_addr,
                             event=event)
        DBSession.add(record)
        DBSession.flush()
        return remember(request, user.id)
    return remember(request, user.id)


def get_came_from(request):
    return request.GET.get('came_from',
                           request.POST.get(
                               'came_from',
                               route_url(buddy_settings('came_from_route'),
                               request))
                           )
