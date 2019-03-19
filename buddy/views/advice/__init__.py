#!/usr/bin/env python
# -*- coding: utf-8 -*-
from buddy.models.user_model import UserFactory
from buddy.models.blogs_model import BlogFactory, CommentFactory
from buddy.models.q_model import QuestionFactory, AnswerFactory


def noprefix_route(config):
    #root factory
    #config.add_route('voices','/voices')
    config.add_route('blog_list','/blogs', factory=BlogFactory)
    #config.add_route('question_list','/questions', factory=CommentFactory)
    config.add_route('user_drafts','/blog-draft/{prefix}/index')
    config.add_route('draft_list','/dsh/draft-list')
    config.add_route('add_blog','/blog-post')



def blog_route(config):
    config.add_route('blog_category_filter','/filter/{id}',factory=BlogFactory)
    #blog factory

    config.add_route('edit_blog','/{name}/edit',factory=BlogFactory, traverse='/{name}')
    config.add_route('blog_delete','/{name}/delete',factory=BlogFactory, traverse='/{name}')
    config.add_route('blog_view','/{name}', factory=BlogFactory,traverse='/{name}')
    #config.add_route('add_comment','/comment/add', factory=CommentFactory)
    #config.add_route("edit_comment","/comments/{comment_id}/edit", traverse="/{comment_id}", factory=CommentFactory)
   # config.add_route('reply_comment','/comments/{comment_id}/{blog_name}/reply')
    #config.add_route("delete_comment","/comment/{comment_id}/delete", traverse="/{comment_id}",factory=CommentFactory)
    config.add_route('image_upload',"/image/imageupload")
    config.add_route("image_delete","image/imagedelete")
    config.add_route('image_browse','image/browser')
    config.add_route("image_manager_delete","imageManager/imagedelete")

'''

def question_route(config):
    #question factory
    config.add_route('ask_questions','/add',factory=QuestionFactory)
    config.add_route('edit_question','/{name}/edit',factory=QuestionFactory,
                     traverse='/{name}')
    config.add_route('view_question','/{name}', factory=QuestionFactory)
    config.add_route('question_delete','{name}/delete',
                     factory=QuestionFactory, traverse='/{name}')
    config.add_route('vote_question','{name}/vote', factory=QuestionFactory)
    config.add_route('question_category_filter','/filter/{filter}')

def answer_route(config):
    config.add_route('add_answer','/{name}/add-answer', factory=AnswerFactory)
    config.add_route("edit_answer","/{name}/delete", traverse="/{name}",factory=AnswerFactory)
'''