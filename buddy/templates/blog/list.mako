<%inherit file="buddy:templates/base/layout.mako"/>
<%!
from bs4 import BeautifulSoup

%>

<div class="container-fluid">
    <section class="content-header">
        <div class="row">
            <div class="col-md-12">
                <ol class="breadcrumb">
            <li><a href="/">Home</a>
            <li class="active"><a href="#">Advice</a></li>
        </ol>
            </div>
        </div>

    </section>
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                %if bcategory:
                    <div class="callout callout-info">
                        %if bcategory.parent:
                <h3>${bcategory.parent.name.upper()}</h3>
                    %endif

    <div class="h4 text-danger">Filter: ${title.capitalize()}</div>

    <hr>
    %if bcategory.parent:
    %if bcategory.parent.description:

    ${literal(bcategory.parent.description.replace('\n','<br>'))}
    <hr style="border-bottom: 2px solid #ddd">
        %endif
        %endif
                    </div>
                    %else:
                    <div class="callout callout-info">
                <h3>Nairabricks Blog</h3>
<p>Our blog site is a place where real estate professionals can write about anything concerning real estate so we can all learn and grow as a community. </p>
<p>It is a community of real estate agents, brokers, lenders, home stagers, home inspectors, contractors and other real estate professionals who are committed to learning one from one another to improve their business, their lives, and the industry.</p>
                <p class="text-danger">Please only write original article. Don't copy from another website</p>
            </div>
                %endif


            </div>
        </div>
        <div class="row">
        <div class="col-md-12">

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
    </section>
</div>
<%include file="category_sidebar.mako"/>
