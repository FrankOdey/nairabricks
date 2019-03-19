from buddy.utils import helpers
from pyramid.httpexceptions import HTTPForbidden

 
def add_renderer_globals(event):
    """ add helpers """
    event['h'] = helpers 
    

def csrf_validation(event):
    if event.request.method == "POST":
        token = event.request.POST.get("csrf_token")
        session_csrf = event.request.session.get_csrf_token()
        if token is None or token !=session_csrf :
            raise HTTPForbidden('CSRF token is missing or invalid token:%s !=%s'%(token,session_csrf))
