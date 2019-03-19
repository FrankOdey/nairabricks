<%inherit file="buddy:templates/user/userbase.mako"/>
<%!
from bs4 import BeautifulSoup

%>
<section>
    <div class="row">
        <div class="col-md-12">
        <div class="box box-primary">
            <div class="box-header">
                <h4 class="box-title">
                    ${user.fullname}'s blog
                </h4>
            </div>
            <div class="box-body">
            %if paginator:
                <div class="row">
                    %for item in paginator.items:
                        <%
          soup = BeautifulSoup(item.body,'html.parser')
          fim = soup.img

        %>
                    <div class="col-md-4">
                        <div class="panel panel-default">
                            <div class="panel-body" style="padding: 0">
                                <a  href="${request.route_url('blog_view',name=item.name)}">
  %if fim:

  <img src="${fim['src']}" alt="${item.title} "   class="img-responsive" style="max-height:150px"/>
      %else:
      <img src="/static/nopics.jpg" alt="${item.title}" class="img-responsive"/>
   %endif

	</a>
                                <div style="padding: 15px;">
                                <h4 class="media-heading"><a href="
${request.route_url('blog_view',name=item.name
			)}">${item.title.capitalize()}</a></h4>
            ${item.excerpt}
	%if item.excerpt!=None and len(item.body)>200:
<a href="${request.route_url('blog_view',
						name=item.name)}">Read More</a>
     %endif
                                </div>
                            </div>
                            <div class="panel-footer">
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
                    %endfor
                </div>
            %endif
                </div>
        </div>
        </div>
            </div>
</section>