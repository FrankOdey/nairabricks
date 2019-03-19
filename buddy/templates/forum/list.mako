<%inherit file="buddy:templates/base/layout.mako"/>

<%
    import string
 %>
<div class="uk-container uk-container-center">
    <ul class="list-inline" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li>&Gt;
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">Q&A</span>
        <meta itemprop="position" content="2" /></li>
    </ul>
<div class="row">
	<div class="col-sm-8">
<div class="hz_yt_bg">
##<%include file="questioncategory.mako"/>
<div class="blog-header">
<i class="uk-icon-question-circle uk-icon-large"></i>


    <article style="font-size: 14px">
        <h3 class="uk-article-title"><strong>Real Estate Q&A</strong>
</h3>
        <p>Our real estate Q&A site is a place where real estate professionals can ask their peers questions so we can
            all learn and grow as a community. </p>
   <p>Members of our community can ask, answer, like, and subscribe to questions. Visitors to our site can read the
       questions and answers.</p>
    <p>Nairabricks is dedicated to helping home owners, home buyers, home sellers, renters, real estate agents, mortgage
        professionals, landlords and property managers, find and share vital information about homes, real estate and
        home improvement.</p>

    </article>
<a href="${request.route_url('ask_questions')}" class="btn btn-pink">Ask question</a>
</div>
<hr>
%if paginator:
%for item in paginator.items:
	
##<div class="media uk-scrollspy-init-inview uk-scrollspy-inview
##uk-animation-slide-left" data-uk-scrollspy="{cls:'uk-animation-slide-left', delay:600, repeat: true}">
<div class="row">
    <div class="col-md-12" >
    <div class="media">
	<a  href="${request.route_url('profile',prefix=item.user.prefix)}" class="pull-left">
%if item.user.photo and not item.anonymous:
  <img src="${request.storage.url(item.user.photo)}"  class="media-object userdetails-img"/>
   %else:
<img src="/static/male avater.png" class="media-object userdetails-img"/>
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
	##<span class="sep">.</span>
##<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
	##<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
##	${item.up}
##<span class="sep">&bull;</span>
##<a href=""><span class="glyphicon glyphicon-flag"></span></a>

%else:
       No Answers
      <span class="sep">.</span>
      <a href="${request.route_url('view_question',name=item.name)}#answerForm">Be the first to Answer</a>
	##<span class="sep">.</span>
##<input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
##	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>
##	${item.up}
##<span class="sep">&bull;</span>
##<a href=""><span class="glyphicon glyphicon-flag"></span></a>

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
	<div class="col-sm-4" >
<div class="hz_yt_bg">
    <a href="${request.route_url('ask_questions')}" class="btn btn-pink btn-block">Ask question</a><br>
<div class="title">
<h4><strong>Be A Good Neighbor</strong></h4>
</div>
Nairabricks Advice depends on each member to keep it a safe, fun, and positive place. If you see abuse, flag it. 
</div>
        <div class="panel panel-default hidden-xs">
            <div class="panel-body">
                <h4>Question CATEGORIES</h4>
                <div id="category-filter" role="tablist" aria-multiselectable="true">
 <ul class="list-unstyled" >
%for category in q_nav_cat:

%if category.children:

         <li class="blog-category-filter"> <a  data-toggle="collapse" data-parent="#category-filter"
             href="#collapse${string.replace(category.name,' ','')}" aria-expanded="true"
             aria-controls="#collapse${string.replace(category.name,' ','')}">${category.name.capitalize()}
             (${childQCount(category)})
          <span class="caret"></span>
          </a></li>
        <div id="collapse${string.replace(category.name,' ','')}" class="collapse">
	<ul class="list-unstyled">
	%for child in category.children:
		<li><a href="${request.route_url('blog_category_filter', filter=child.name)}">${child.name.capitalize()}(${len(child.questions)})</a></li>
	%endfor
		</ul>
            </div>

%endif
%endfor
</ul>
</div>
            </div>
        </div>
        ${h.featured_professionals(request)|n}
	</div>
</div>
</div><!-- /.ends container -->	
		
<%def name="childQCount(category)">
    <%
        d = 0
        %>

    %for child in category.children:
        <%
        d+= len(child.questions)
            %>
     %endfor
        ${d}
</%def>