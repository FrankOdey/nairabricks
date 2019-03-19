<%inherit file="buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%!
    from webhelpers.html import literal
%>
<%block name="script_tags">
${parent.script_tags()}

	<script>

$(document).ready(function(){
	$('#answerForm').validate();
    $("#editor").on('focus',function(){
       editor =  $("#editor").ckeditor();
    });
});
</script>
</%block>
<%block name="header_tags">
    ${parent.header_tags()}
<link href="/static/froala/css/froala_style.min.css" rel="stylesheet" type="text/css">
</%block>

<div class="container">
    <ul class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('question_list')}"><span itemprop="name">Q&A</span></a>
        <meta itemprop="position" content="2" /></li>
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${question.title}</span>
        <meta itemprop="position" content="3" /></li>
    </ul>
<div class="row">
	<div class="col-sm-8">

<div class="hz_yt_bg">

<div class="blog-header">
    <p>
     %if request.has_permission('edit'):
        <a href="${request.route_url('edit_question',name = question.name)}" style="font-size:10px;">Edit</a>

    %endif
    %if request.has_permission('admin'):
       | <a href="${request.route_url('question_delete',
						name=question.name)}" style="font-size:10px;">delete</a>
    %endif
    </p>
%if question.anonymous:
	<h4><Strong>Anonymous Question</strong>

</h4>
%else:
<h4><strong><a href="${request.route_url('user_questions', prefix=question.user.prefix)}">${question.user.fullname.title()}'s Questions</a></strong></h4>
%endif
</div>
<div class="media" id="view-media" style="background:#f4f4f4; padding:5px; font-size:10px">
  <a class="pull-left" href="#">
    %if question.user.photo and not question.anonymous:
  <img src="${request.storage.url(question.user.photo)}" class="media-object img-responsive img-thumb"/>
   %else:
<img class="media-object img-responsive img-thumb" src="/static/male avater.png">
%endif
  </a>
  <div class="media-body">
%if question.anonymous:
	Anonymous
%else:
By <a href="${request.route_url('profile',prefix = question.user.prefix)}">${question.user.fullname}</a> |

%if question.user.user_type :
 ${question.user.user_type.name}
 %if question.user.company_name:
 at ${question.user.company_name}
 %endif
%endif
<br>
%if question.user.user_type and question.user.user_type.name.lower() !='other/just looking':
 <span class="label label-danger">PRO</span>
 %endif
%endif
  </div>
</div>
<div class="h5">
<strong>${question.title}</strong>
</div>
<div class="fr-view">${literal(question.body)}</div>
    <p class="timestamp">Asked ${question.timestamp} under <span class="uk-icon-arrow-right"></span>
    %for cate in question.categories:
<a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep">&bull;</span>
%endfor
      </p>

<div class="comment">
<a href=""><span data-value="${question.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>

<span class="sep">&bull;</span>
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

</div>

<div class="table-responsive" style="margin-top: 20px;">
<table class="table">
<tr id="social">
<td>
    ##<a href=""><span class="glyphicon glyphicon-envelope"></span>
  ##Email Alerts</a></td>
<td>${self.tweet()}</td>
<td><div class="fb-send" data-href="${request.route_url('view_question',name=question.name)}" data-colorscheme="light"></div></td>
<td><div class="fb-share-button" data-href="${request.route_url('view_question',name=question.name)}" data-type="link"></div></td>
</tr>
</table>
</div>
%if question.answers:
<div class="title" id="answers">
<h4><strong>Answers(${len(question.answers)})</strong></h4>
</div>
%for answer in question.answers:
<div class="media">
  <a class="pull-left" href="#">
   %if answer.user.photo and not answer.anonymous:
  <img src="${request.storage.url(answer.user.photo)}" class="media-object" width="100" height="100"/>
   %else:
<img class="media-object" width="100" height="100" src="/static/male avater.png">
%endif
  </a>
  <div class="media-body">
	<div class="uk-text-break">${literal(answer.body.replace('\n',"<br>"))}</div>
<div class="timestamp">
Answered ${answer.timestamp} by 
%if answer.anonymous:
	Anonymous
%else:
<a href="${request.route_url('profile',prefix=answer.user.prefix)}">${answer.user.fullname}
     <small style="font-size: 10px">
          %if answer.user.user_type:
  ${answer.user.user_type.name}
            %if answer.user.company_name:
                with ${answer.user.company_name}
            %endif
%endif
      </small>
      </a>
%endif
</div>
<div class="comment">
<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	<a href=""><span data-value="${answer.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
	${answer.up}
<a href=""><span class="glyphicon glyphicon-flag"></span></a>

</div>
</div>
</div>
%endfor
%endif
<div class="h4">
Your Answer
</div>
<div class="media">
  <a class="pull-left" href="#">
    %if request.user and request.user.photo:
  <img src="${request.storage.url(request.user.photo)}" class="media-object img-responsive img-thumb"/>
   %else:
<img class="media-object img-responsive img-thumb" src="/static/male avater.png">
%endif
  </a>
  <div class="media-body">

${form.begin(url=request.route_url('add_answer', name=question.name),method="post",id="answerForm",class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
${form.hidden('q_id',value=question.id)}
${form.hidden("came_from",value=came_from, class_="form_control")}
${form.textarea(name="body" ,id="editor", class_="form-control required",placeholder="Your answer")}
${form.checkbox("anonymous",label="Post as anonymous", class_="form_control")}
<br>
<button type="submit" name="form_submitted" class="btn btn-pink pull-right">Submit</button>
${form.end()}


  </div>
</div>
</div>
	</div>

	<div class="col-sm-4">
<div class="hz_yt_bg">
    <div class="title">
	<h4><strong>Be A Good Neighbor</strong></h4>
	</div>
    Nairabricks Advice depends on each member to keep it a safe, fun, and positive place. If you see abuse, flag it.
</div>
	</div>
</div>
</div><!-- /.ends container -->	

<%def name="tweet()">
<a href="https://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</%def>