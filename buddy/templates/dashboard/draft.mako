<%inherit file="buddy:templates/base/layout.mako"/>
<%!
from pyramid.security import has_permission
import string
from bs4 import BeautifulSoup

%>

<%include file="buddy:templates/blog/blogcategory.mako"/>
<div class="container">


<div class="row">
	<div class="col-sm-12">
<div class="hz_yt_bg" >
<div class="page-header">
<h3><strong>Drafts</strong>
</h3>
</div>
    <%doc>
    <article>
        <p>Nairabricks RealEstate Blog is a platform where realestate professionals educate the people on
        various issues concerning realestate. It is free and you can start blogging right now by following this
            <a href="${request.route_url('add_blog')}">link</a></p>
    </article>
    </%doc>

%if paginator:
<%
    table = h.distribute(paginator.items,4,'H')
    %>
    %for row in table:
             <div class="row">
             %for item in row:
                 %if item:
         <%
          soup = BeautifulSoup(item.body,'html.parser')
          fim = soup.img

        %>
            <div class="col-md-3">
        <div class="media">
	<a  href="${request.route_url('blog_view',name=item.name)}" class="">
  %if fim:
  <img src="${fim['src']}" alt="${item.title} "  class="media-object" width="250" height="150"/>
      %else:
      <img src="https://placehold.it/250x150?text=No+Image" alt="${item.title}" class="media-object"/>
   %endif
	</a>
<div class="media-body" style="padding-top: 10px">
	<h4 class="media-heading"><a href="
${request.route_url('blog_view',name=item.name
			)}">${item.title.capitalize()}</a></h4>


            ${item.excerpt}
	%if item.excerpt!=None and len(item.body)>200:
<a href="${request.route_url('blog_view',
						name=item.name)}">Read More</a>
     %endif


	<div class="timestamp">
Blogged ${item.timestamp} by <a href="${request.route_url('profile',prefix=item.user.prefix)}">${item.user.fullname}</a>
 under <span class="uk-icon-arrow-right"></span>
%if item.categories:
	%for cate in item.categories:
	<span class="sep">&bull;</span><a href="${request.route_url('blog_category_filter',id=cate.id,filter=cate.name)}">${cate.name}</a><span class="sep"></span>
	%endfor
%endif
<div class="comment">
    <span class="fb-comments-count" data-href="${request.route_url('blog_view',
						name=item.name)}"></span> comments
    <%doc>
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
</%doc>
    %if request.has_permission('admin'):
        <span class="sep">&bull;</span>
        <i>pageviews ${item.total_view}</i>
    %endif

                          </div>
		</div>

	</div>
</div>
            </div>
                 %endif
                 %endfor
        </div>
%endfor
<p class="pull-right"> ${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-pink btn-sm"},
	curpage_attr={"class":"btn btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
%else:

<p>We currently do not have any blog post here, please <a href="${request.route_url('add_blog')}">Write one</a></p>

%endif
</div>
	</div>
    <%doc>
	<div class="col-sm-4">

        <div class="panel panel-default">
            <div class="panel-body">
                <h4>BLOG CATEGORIES</h4>
                <div id="category-filter" role="tablist" aria-multiselectable="true">
 <ul class="list-unstyled" >
%for category in blog_nav_cat:

%if category.children:

         <li class="blog-category-filter"> <a  data-toggle="collapse" data-parent="#category-filter"
             href="#collapse${string.replace(category.name,' ','')}" aria-expanded="true"
             aria-controls="#collapse${string.replace(category.name,' ','')}">${category.name.capitalize()}
             (${childBlogCount(category)})
          <span class="caret"></span>
          </a></li>
        <div id="collapse${string.replace(category.name,' ','')}" class="collapse">
	<ul class="list-unstyled">
	%for child in category.children:
		<li><a href="${request.route_url('blog_category_filter', filter=child.name)}">${child.name.capitalize()}(${len(child.blogs)})</a></li>
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
	</%doc>
</div>
</div><!-- /.ends container -->

<%def name="childBlogCount(category)">
    <%
        d = 0
        %>

    %for child in category.children:
        <%
        d+= len(child.blogs)
            %>
     %endfor
        ${d}
</%def>