<%inherit file="buddy:templates/base/layout.mako"/>

<div class="uk-container uk-container-center">

<div class="uk-grid">
	<div class="uk-width-medium-7-10">
<div class="blog-wrapper">
<div class="uk-article-title">
Voices <i class="uk-icon-bullhorn uk-icon-large"></i>
</div>
%if paginator:
%for item in paginator.items:
%if item.type=='blog':

<div class="media" id="media">
	<a class="pull-left" href="">
  %if item.user.photo:
  <img src="${request.storage.url(item.user.photo)}" width="40"/>
   %else:
<img class="media-object" src="/static/male avater.png" width="40">
%endif
	</a>
	<div class="media-body">
	<h4 class="media-heading"><a href="
${request.route_url('blog_view',name=item.name
			)}">${item.title.capitalize()}</a></h4>
<div class="row">
	<div class="col-sm-10">
	${item.excerpt}

	%if item.excerpt!=None and len(item.body)>200:
<a href="${request.route_url('blog_view',
						name=item.name)}">Read More</a>
     %endif
	</div>
	<div class="col-sm-2">
	</div>
</div>
	<div class="timestamp">
Blogged ${item.timestamp} by <a href="${request.route_url('profile',prefix=item.user.prefix)}">${item.user.fullname}</a>
 under <span class="uk-icon-arrow-right"></span>
%if item.categories:
	%for cate in item.categories:
	<span class="sep">&bull;</span><a href="${request.route_url('blog_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
	%endfor
%endif
<div class="comment">
%if item.comments:
	<a href="${request.route_url('blog_view',
						name=item.name)}#comments">${len(item.comments)} Comments</a>
	<span class="sep">&bull;</span>
	<a href="${request.route_url('blog_view',
						name=item.name)}#commentForm">Add a comment</a>
%else:
                            No comments
              <span class="sep">&bull;</span>

	<a href="${request.route_url('blog_view',
						name=item.name)}#commentForm">Be the first to Comment</a>
%endif
                          </div>
		</div>

	</div>
</div>
%elif item.type=='question':

<div class="media" id="media">
	<a class="pull-left" href="">
%if item.user.photo:
  <img src="${request.storage.url(item.user.photo)}" width="40"/>
   %else:
<img class="media-object" src="/static/male avater.png" width="40">
%endif
	</a>
	<div class="media-body">
	<h4 class="media-heading"><a href="
${request.route_url('view_question',name=item.name
			)}">${item.title}</a></h4>
	${item.excerpt}
%if item.excerpt!=None and len(item.excerpt)>200:
<a href="${request.route_url('view_question',
						name=item.name)}">Read More</a>
 %endif
	<div class="timestamp">
Asked ${item.timestamp} by 
%if item.anonymous:
	Anonymous
%else:
<a href="${request.route_url('profile',prefix=item.user.prefix)}">${item.user.fullname}</a>
%endif
  under <span class="uk-icon-arrow-right"></span>
  %if item.categories:
	%for cate in item.categories:
	<span class="sep">&bull;</span><a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
	%endfor
%endif
<div class="comment">
%if item.answers:
	<a href="${request.route_url('view_question',name=item.name)}#answers">${len(item.answers)} Answers</a>
	<span class="sep">.</span>
	<a href="${request.route_url('view_question',name=item.name)}#answerForm">Answer this question</a>
	<span class="sep">.</span>
<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
	${item.up}
<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%else:
       No Answers
      <span class="sep">.</span>
      <a href="${request.route_url('view_question',name=item.name)}#answerForm">Be the first to Answer</a>
	<span class="sep">.</span>
<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
	${item.up}
<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%endif
                          </div>
		</div>
	</div>
</div>

<!--/question -->
%endif
%endfor
%else:
<p>We currently do not have any post here, please <a href="${request.route_url('add_blog')}">add one</a></p>
%endif
</div>
</div>
<div class="uk-width-medium-3-10">
<div class="wrapper">
<div class="page-header">
	<h4><strong>Let your voice be heard!</strong></h4>
</div>
<strong>Voice it out, your voice deserves to be heard</strong>
<p>This is the best way of sharing what you know. How should people avoid scam? Help them and get discovered</p>
 <strong>It is the best way to get discovered</strong>
<p>Give advice to people, tell them what is actually happenning in realestate and we will get it to them</p>
  <strong>Chat with others who share common interests with you</strong>
<p>Start a conversation about your city and locality, your new tiles or your obsession with real estate.</p>

	</div>
	</div>
</div>
</div>