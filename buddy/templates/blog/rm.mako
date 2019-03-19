<%inherit file="buddy:templates/base/layout.mako"/>
<%!
from pyramid.security import has_permission
import string, os
from bs4 import BeautifulSoup

%>

##<%include file="blogcategory.mako"/>
<div class="container">
<%doc>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- BlogListTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="5387606527"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</%doc>
<div class="row">
	<div class="col-sm-8">

<div class="hz_yt_bg" >

<div class="page-header">

<a href="${request.route_url('add_blog')}" class="btn btn-site pull-right">Post</a>

<h3><strong>Nairabricks Blog</strong>
</h3>
<p>Our blog site is a place where real estate professionals can write about anything concerning real estate so we can all learn and grow as a community. </p>
<p>It is a community of real estate agents, brokers, lenders, home stagers, home inspectors, contractors and other real estate professionals who are committed to learning one from one another to improve their business, their lives, and the industry.</p>
<p class="text-danger">Please only write original article. Don't copy from another website
</div>

<div class="row">
    <div class="col-md-8">
        %if paginator:
<%
    table = h.distribute(paginator.items,2,'H')
    %>
    %for row in table:
             <div class="row">
             %for item in row:

                 %if item:
         <%
          soup = BeautifulSoup(item.body,'html.parser')
          fim = soup.img

        %>
            <div class="col-md-6">
        <div class="media">
	<a  href="${request.route_url('blog_view',name=item.name)}" class="">
  %if fim:

  <img src="${fim['src']}" alt="${item.title} "  class="media-object" style="min-width: 100%; max-height:180px" />
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
 under <span class="glyphicon glyphicon-arrow-right"></span>
%if item.categories:
	%for cate in item.categories:
	<span class="sep">&bull;</span><a href="${request.route_url('blog_category_filter',id=cate.id)}">${cate.name}</a><span class="sep"></span>
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
    <div class="col-md-4">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- BlogList Sidebar Responsive -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="6509256124"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
    </div>
</div>


</div>
	</div>

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
		<li><a href="${request.route_url('blog_category_filter', id=child.id)}">${child.name.capitalize()}(${len(child.blogs)})</a></li>
	%endfor
		</ul>
            </div>

%endif
%endfor
</ul>
</div>
            </div>
        </div>
       ##${h.featured_professionals(request)|n}

	</div>

    </div>
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- BlogListBottom -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="8341072926"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
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