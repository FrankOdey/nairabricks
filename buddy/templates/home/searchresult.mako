<%inherit file = "buddy:templates/base/layout.mako"/>
<%block name="script_tags">
${parent.script_tags()}
    <script>
    $(document).ready(function(){
    $('#property_type').multiselect({
      maxHeight: 200,
     numberDisplayed:1,
    buttonContainer: '<span class="dropdown" />',
     nSelectedText:'Property type selected',
        nonSelectedText:'Any property type'

    });
    $('#type').multiselect();
});
    </script>
</%block>

<div class="uk-container uk-container-center">
<div class="grid">
	<div class="uk-width-medium-7-10" >
<div class="blog-wrapper">

%if paginator:
    <div class="page-header">
        Your search returned ${len(paginator.items)} items
    </div>
    %for item in paginator.items:
        %if item.type=='blog':
        ${self.blogview(item)}
        %elif item.type=='question':
        ${self.questionview(item)}
        %endif
    %endfor
%else:
    No items found
%endif
</div>
</div>
<div class="uk-width-medium-3-10">

</div>
</div>
</div>


<%def name="questionview(item)">
    <div class="media uk-scrollspy-init-inview uk-scrollspy-inview
uk-animation-slide-left" data-uk-scrollspy="{cls:'uk-animation-slide-left', delay:600, repeat: true}" id="media">
	<a class="pull-left" href="">
%if item.user.photo:
  <img src="${request.storage.url(item.user.photo)}" class="media-object" width="40"/>
   %else:
<img class="media-object" width="40" src="/static/male avater.png">
%endif
	</a>
	<div class="media-body">
	<h4 class="media-heading"><a href="
${request.route_url('view_question',name = item.name
			)}">${item.title}</a></h4>
	${item.excerpt}

<a href="${request.route_url('view_question',
						name = item.name)}">Read More</a>
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
	<span class="sep">&bull;</span>
	<a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
	%endfor
%endif
<div class="comment">
%if item.answers:
	<a href="${request.route_url('view_question',name = item.name)}#answers">${len(item.answers)} Answers</a>
	<span class="sep">.</span>
	<a href="${request.route_url('view_question',name = item.name)}#answerForm">Answer this question</a>
	<span class="sep">.</span>
<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
	${item.up}
<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%else:
       No Answers
      <span class="sep">.</span>
      <a href="${request.route_url('view_question',name= item.name)}#answerForm">Be the first to Answer</a>
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


</%def>






<%def name="blogview(item)">
    <div class="media uk-scrollspy-init-inview uk-scrollspy-inview
uk-animation-slide-left" data-uk-scrollspy="{cls:'uk-animation-slide-left', delay:600, repeat: true}" id="media">
	<a class="pull-left" href="">
  %if item.user.photo:
  <img src="${request.storage.url(item.user.photo)}" class="media-object" width="40"/>
   %else:
<img class="media-object" src="/static/male avater.png" width="40">
%endif
	</a>
	<div class="media-body">
	<h4 class="media-heading"><a href="
${request.route_url('blog_view',name = item.name
			)}">${item.title.capitalize()}</a></h4>
<div class="row">
	<div class="col-sm-10">
	${item.excerpt}
<a href="${request.route_url('blog_view',
						name = item.name)}">Read More</a>
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
						name = item.name)}#comments">${len(item.comments)} Comments</a>
	<span class="sep">&bull;</span>
	<a href="${request.route_url('blog_view',
						name = item.name)}#commentForm">Add a comment</a>
%else:
                            No comments
              <span class="sep">&bull;</span>

	<a href="${request.route_url('blog_view',
						name = item.name)}#commentForm">Be the first to Comment</a>
%endif
                          </div>
		</div>

	</div>
</div>
</%def>