<%inherit file="buddy:templates/base/layout.mako"/>

<div class="uk-container uk-container-center">
<div class="uk-grid" data-uk-margin>
	<div class="uk-width-medium-7-10">

<div class="blog-wrapper">
<%include file="questioncategory.mako"/>
    <i class="uk-icon-question-circle uk-icon-large"></i>
<div class="blog-header">

</div>
    <article>
        <div class="uk-article-title">Filter: ${title.capitalize()}</div>
    </article>
    <hr>
%if paginator:
%for item in paginator.items:

##<div class="media uk-scrollspy-init-inview uk-scrollspy-inview
##uk-animation-slide-left" data-uk-scrollspy="{cls:'uk-animation-slide-left', delay:600, repeat: true}">
<div class="uk-grid">
    <div class="uk-width-1-1" >
    <div class="media">
	<a  href="${request.route_url('profile',prefix=item.user.prefix)}" class="pull-left">
%if item.user.photo:
  <img src="${request.storage.url(item.user.photo)}"  width="70" class="media-object"/>
   %else:
<img src="/static/male avater.png" width="70" class="media-object"/>
%endif
	</a>
        <div class="media-body">
	<h4 class="media-heading"><a href="
${request.route_url('view_question',name=item.name
			)}">${item.title}</a></h4>
	${item.excerpt}
%if item.excerpt!=None and len(item.body)>200:
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
	<span class="sep">&bull;</span>  <a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
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

<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%else:
       No Answers
      <span class="sep">.</span>
      <a href="${request.route_url('view_question',name=item.name)}#answerForm">Be the first to Answer</a>
	<span class="sep">.</span>
<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>

<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%endif
                          </div>
		</div>
	</div>
</div>
    </div>
    </div>
%endfor
    <div class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</div>
%else:
<p>We currently do not have any question here, please <a href="${request.route_url('ask_questions')}">Ask question</a></p>

%endif
</div>
	</div>
	<div class="uk-width-medium-3-10" >
<div class="wrapper">
<div class="title">
<h4><strong>Be A Good Neighbor</strong></h4>
</div>
Nairabricks Advice depends on each member to keep it a safe, fun, and positive place. If you see abuse, flag it.
</div>
	</div>
</div>
</div><!-- /.ends container -->

