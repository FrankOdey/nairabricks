<%inherit file = "buddy:templates/dash/base.mako"/>
<%!
from bs4 import BeautifulSoup

%>
<section class="content-header">
      <h1>
        Dashboard
          <small>My Blog Posts</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="#">My Blog Posts</a></li>
      </ol>
    </section>
<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#post" data-toggle="tab" aria-expanded="true">Posts</a></li>
              <li class=""><a href="#draft" data-toggle="tab" aria-expanded="false">Drafts</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="post">
                    %if postpaginator:
                <div class="row">
                    %for item in postpaginator.items:
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
            <ul class="list-inline">
            <li><a href="${request.route_url('edit_blog',
						name=item.name)}" >Edit</a></li>
            <span class="sep">&bull;</span>
        <i>pageviews ${item.total_view}</i>
                                        </ul>

                          </div>
                            </div>
                            </div>
                        </div>
                    %endfor
                </div>
            %endif
                </div>
                <div class="tab-pane" id="draft">
                    %if draftpaginator:
                <div class="row">
                    %for item in draftpaginator.items:
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
                                    <ul class="list-inline">
            <li><a href="${request.route_url('edit_blog',
						name=item.name)}" >Edit</a></li>
            <span class="sep">&bull;</span>
        <i>pageviews ${item.total_view}</i>
                                        </ul>
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
    </div>
</section>