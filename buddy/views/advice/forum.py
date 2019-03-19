
'''
from pyramid.view import view_config
from sqlalchemy import or_
from pyramid.httpexceptions import HTTPFound
from pyramid_simpleform import Form
from pyramid_simpleform.renderers import FormRenderer
from webhelpers.paginate import PageURL_WebOb, Page
from buddy.models.resources import Content
from buddy.utils.url_normalizer import urlify_name
from buddy.views.advice.schema import QuestionPost, AnswerPost
from buddy.views.advice.blog import histogram
from buddy.models.properties_model import State
from buddy.models.q_model import Questions,QCategory,Answers
from buddy.models.user_model import Users
from buddy.models import DBSession
import transaction, json
from buddy.views.messages import html_email_sender

desc = "Nairabricks Real Estate Q&A aims to provide a platform where you can get answers quickly on anything" \
        " about realestate. At the same time, real estate professionals promote themselves with their follow up answers. "
def get_states():
    query = [(s.id,s.name) for s in DBSession.query(State).all()]
    return query
def get_qcategories():
    p = DBSession.query(QCategory).all()
    d=[]
    for category in p:
        if category.children:
            f=[(child.id, child.name) for child in category.children]
            f=f,category.name
            d.append(f)
    return d

def get_categories():
    return DBSession.query(QCategory).all()


class QuestionView(object):
    def __init__(self,request):
        self.request = request
        self.session = request.session
        
    @view_config(route_name="ask_questions",renderer= "buddy:templates/forum/new.mako",
                 permission="post")
    def ask_questions(self):
        if not self.request.user.email_verified:
            return HTTPFound(location=self.request.route_url('confirm_mail_holder'))
        dbsession=DBSession()
        states = get_states()
        categories = get_qcategories()
        form=Form(self.request, schema=QuestionPost)
        title = 'Ask a question'
        if "form_submitted" in self.request.POST and form.validate():
            quest = form.bind(Questions(user = self.request.user,
                                        name=urlify_name(form.data['title'])),
                              exclude=["category_id"])
            for category in form.data['category_id']:
                t = DBSession.query(QCategory).get(category)
                quest.categories.append(t)
            quest.name = urlify_name(form.data['title'])
            dbsession.add(quest)

            dbsession.flush()
            return HTTPFound(location=self.request.route_url('view_question',name=quest.name))
        
        return {'form':FormRenderer(form),'aq':'aq','states':states,'title':title,'q_nav_cat':get_categories(),
                'categories':categories}
    
    @view_config(route_name="edit_question",renderer= "buddy:templates/forum/edit.mako",
                 permission='post')
    def edit(self):
        dbsession=DBSession()
        name=self.request.matchdict['name']
        question = Questions.get_by_name(name)
        if not question:
            self.session.flash("danger; No such question entry")
            return HTTPFound(location=self.request.route_url('question_list'))
        states = get_states()
        categories = get_qcategories()
        if not question:
            self.request.session.flash('danger; question not found')
            return HTTPFound(location=self.request.route_url('question_list'))
        title = "Editing " + question.title
        form=Form(self.request, schema=QuestionPost, obj=question)
        if "form_submitted" in self.request.POST and form.validate():
            form.bind(question, exclude=['category_id'])
            for i, cat in enumerate(question.categories):
                if cat.id not in form.data['category_id']:
                    del question.categories[i]
            catids = [cat.id for cat in question.categories]
            for cate in form.data['category_id']:
                if cate not in catids:
                    t = DBSession.query(QCategory).get(cate)
                    question.categories.append(t)
            with transaction.manager:
                dbsession.add(question)
                dbsession.flush()
                return HTTPFound(location=self.request.route_url('view_question',name=question.name))
        return {'form':FormRenderer(form),'states':states,'title':title,'q_nav_cat':get_categories(),
                'categories':categories,'question':question}
    
    @view_config(route_name="view_question",renderer = "buddy:templates/forum/view.mako")
    def view(self):
        referer = self.request.url
        came_from = self.request.params.get('came_from',referer)
        form = Form(self.request,schema=AnswerPost)
        name = self.request.matchdict['name']
        question = Questions.get_by_name(name)
        if not question:
            self.session.flash("danger; No such question entry")
            return HTTPFound(location=self.request.route_url('question_list'))
        title = question.title

        return dict(question=question, title=title,q_nav_cat=get_categories(),came_from=came_from, form=FormRenderer(form))
    
    @view_config(route_name="question_list",renderer='buddy:templates/forum/list.mako')
    def q_list(self):
        title = "Question Voices"
        form = Form(self.request)
        categories = get_categories()
        page = int(self.request.params.get('page', 1))
        paginator = Questions.get_paginator(self.request, page)
        return {'paginator':paginator,'form':FormRenderer(form),'q_nav_cat':categories,'title':title,"page_description":desc}
    
    @view_config(route_name = 'question_category_filter', 
                renderer="buddy:templates/forum/filter.mako")
    def filterd(self):
        form = Form(self.request)
        categories = get_categories()
        c_filter = self.request.matchdict['filter']
        query = DBSession.query(Questions).\
              filter(Questions.categories.any(name=c_filter)).all()
        page_url = PageURL_WebOb(self.request)
        paginator = Page(query, 
                     page=int(self.request.params.get("page", 1)), 
                     url=page_url)
        title = c_filter
        return {'paginator':paginator,'form':FormRenderer(form),'q_nav_cat':categories,
                "page_description":c_filter+". "+desc, 'title':title}

    @view_config(route_name="user_questions", renderer="buddy:templates/forum/userquestions.mako")
    def userq(self):
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        questions = user.content.filter(Content.type=='question').order_by(Content.created.desc()).all()
        questions = [q for q in questions if q.anonymous==False]
        bc=[s.categories for s in questions]
        bc = histogram(bc)
        form = Form(self.request)
        title=user.fullname + "'s Questions"
        page_url = PageURL_WebOb(self.request)
        paginator = Page(questions,
                     page=int(self.request.params.get("page", 1)),
                     items_per_page=5,
                     url=page_url)
        return dict(user=user,paginator=paginator,q_nav_cat=get_categories(),
                    form=FormRenderer(form),q='q', title=title, bcategories=bc,page_description=user.fullname+"'s questions. "+desc)

    @view_config(route_name="user_question_filter", renderer="buddy:templates/forum/userquestions.mako")
    def userqfilter(self):
        path= self.request.matchdict['prefix']
        form = Form(self.request)
        #id = self.request.matchdict['id']
        category = self.request.matchdict['category']
        user = Users.get_by_path(path)
        questions = user.content.filter(Content.type=='question').filter(Questions.categories.any(name=category)).all()
        bcategor = user.content.filter(Content.type=='question').filter(Questions.user_id==user.id).all()
        bc=[s.categories for s in bcategor]
        bc = histogram(bc)
        title=user.fullname + "'s Questions on "+ category
        page_url = PageURL_WebOb(self.request)
        paginator = Page(questions,
                     page=int(self.request.params.get("page", 1)),
                     items_per_page=5,
                     url=page_url)
        return dict(user=user,paginator=paginator,q_nav_cat=get_categories(),
                    form=FormRenderer(form), title=title, bcategories=bc,category=category)

    @view_config(route_name="question_delete", permission="post")
    def delete(self):
        name = self.request.matchdict['name']
        question = Questions.get_by_name(name)
        if not question:
            self.request.session.flash("warning; no such question")
            return HTTPFound(location=self.request.route_url('question_list'))
        user= question.user
        with transaction.manager:

            body = """<html><head></head><body>
                    <p>Dear %s,<p><br>

                    <p>Your question <a href="%s">%s</a> has just been deleted. This might be because of self promotion,
                    abuse or outright violation of our good neighbor policy</p>
                    <p>Please, you are only allowed to write articles that will help our community</p>

                    <p>Yours sincerely,<br>
                    The Happy Nairabricks Info Robot</p>
                    </body>
                    </html>
                    """%(user.fullname,self.request.route_url('view_question', name=question.name),question.title)
            html_email_sender(self.request,
                subject = "Question deleted",
                recipients=user.email,
                body = body
                )
            DBSession.delete(question)
            self.request.session.flash("success;  question deleted")
            return HTTPFound(location=self.request.route_url('question_list'))


    @view_config(route_name="add_answer",request_method="POST",permission="post")
    def add_answer(self):
        if not self.request.user.email_verified:
            return HTTPFound(location=self.request.route_url('confirm_mail_holder'))
        qname = self.request.matchdict['name']
        question = Questions.get_by_name(qname)
        if not question:
            self.session.flash('warning; Question not found')
            return HTTPFound(location=self.request.route_url('/'))
        referer = self.request.url
        came_from = self.request.params.get('came_from',referer)
        form = Form(self.request,schema=AnswerPost)
        if 'form_submitted' in self.request.POST and form.validate():
            answer = form.bind(Answers(name=urlify_name(question.name)),
                               )
            answer.user = self.request.user
            with transaction.manager:
                DBSession.add(answer)

                DBSession.flush()
                return HTTPFound(location = came_from+'#answers')
        return HTTPFound(location = came_from+'#answerForm')

    @view_config(route_name="edit_answer", permission="edit",renderer="buddy:templates/forum/edit_answer")
    def edit_answer(self):
        name = self.request.matchdict['name']
        pass

    @view_config(route_name="user_answers", renderer="buddy:templates/forum/useranswers.mako")
    def usera(self):
        path= self.request.matchdict['prefix']
        user = Users.get_by_path(path)
        answers = user.content.filter(Content.type=='answer').order_by(Content.created.desc()).all()

        form = Form(self.request)
        title=user.fullname + "'s Answers"
        page_url = PageURL_WebOb(self.request)
        paginator = Page(answers,
                         page=int(self.request.params.get("page", 1)),
                         items_per_page=5,
                         url=page_url)
        total_answers = len([x for x in answers if not x.anonymous])
        return dict(user=user,paginator=paginator,total_answers=total_answers,
                    form=FormRenderer(form),a='a', title=title)

    @view_config(route_name="vote_question", permission="post",renderer="json")
    def vote_q(self):
        params = self.request.params
        if params.get('csrf')!=self.request.session.get_csrf_token():
            return dict(isOk=0,message="Invalid session token")
        name = params.get('name')
        question = Questions.get_by_id(name)
        if self.request.user.id == question.user.id:
            return dict(isOk=0,message="You cannot vote on your on question")
        question.vote(self.request.user,True)
        DBSession.flush()
        
        return dict(isOk=1,message="You have voted this question up")

'''