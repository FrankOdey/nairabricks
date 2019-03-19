<%inherit file="buddy:templates/user/userbase.mako"/>
<%!
from pyramid.security import has_permission
import string
from bs4 import BeautifulSoup

%>

<div class="row">
        <div class="col-sm-12">
        <div class="hz_yt_bg">
%if has_permission('edit',user,request):
            <h1>Your drafts</h1>

            %if category:

            <div class="h3 text-center"><span style="border-bottom: 2px solid #9f0e8e">${category.upper()}</span> </div>
                 %endif

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

<p>${user.fullname} has not written any blog post yet</p>

%endif


        %endif

            </div>
        </div>

    </div>
