<%inherit file="buddy:templates/base/layout.mako"/>

<%!
    from webhelpers.html import literal
    from pyramid.security import has_permission
    from bs4 import BeautifulSoup
%>
<%block name="header_tags">
${parent.header_tags()}
    <meta property="og:url"           content="${request.route_url('blog_view',name=blog.name)}" />
    <meta property="og:type"          content="article" />
    <meta property="og:title"         content="${blog.title}" />
    <meta property="og:description"   content="" />
    <meta property="fb:app_id" content="1649187415295923"/>

        <%
            soup = BeautifulSoup(blog.body,'html.parser')
            fimage = soup.img

          %>
    %if fimage:
     <meta property="og:image" content="${fimage['src']}"/>
	 <meta name="twitter:image" content="${fimage['src']}">
    %endif
	<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@nairabricks">
<meta name="twitter:creator" content="@nairabricks">
<meta name="twitter:title" content="${blog.title}">
    <meta name="twitter:description" content="${blog.excerpt}">

    <!-- CSS rules for styling the element inside the editor such as p, h1, h2, etc. -->
<link href="/static/froala/css/froala_style.min.css" rel="stylesheet" type="text/css" />
</%block>
<%block name="script_tags">
${parent.script_tags()}
<script>
    $(function(){
    $('#commentForm').validate();
     $('.reply').on('click', function(){
         $(this).next('div').show();
     });
    });

</script>
    </%block>
##<%include file="blogcategory.mako"/>
<div class="container-fluid">
    <section class="content-header">
        <div class="row">
            <div class="col-md-12">
    <ul class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('blog_list')}"><span itemprop="name">Blogs</span></a>
        <meta itemprop="position" content="2" /></li>
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${blog.title}</span>
        <meta itemprop="position" content="3" /></li>
    </ul>
                </div>
        </div>
        </section>
    <%doc>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- BlogViewTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="3771272525"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</%doc>
    <section class="content">
<div class="row">
	<div class="col-sm-8">
        <div class="box box-info">
            <div class="box-body">
                %if blog.status==False:
    <p class="text-danger"> This blog is in draft mode. Edit the blog and click publish to have it published</p>
                %endif
        <div class="post">
                  <div class="user-block">
                      <a href="${request.route_url('profile',prefix=user.prefix)}">
                      %if user.photo:
                          <img class="img-circle img-bordered-sm" src="${request.storage.url(blog.user.photo)}" alt="user image">
                          %else:
                          <img class="img-circle img-bordered-sm" src="/static/maleavater.png" alt="user image">
                      %endif
                      </a>
                        <span class="username">
                          <a href="${request.route_url('profile',prefix=user.prefix)}">${user.fullname}</a>
                        </span>
                    <span class="description">${blog.timestamp} &bull;
    %if request.has_permission('edit'):
        <a href="${request.route_url('edit_blog',
						name=blog.name)}" >Edit</a>
    %endif
                    </span>
                       <p class="timestamp">
Posted under <span class="glyphicon glyphicon-arrow-right"></span>
   %for cate in blog.categories:
<a href="${request.route_url('blog_category_filter',id=cate.id)}">${cate.name}</a><span class="sep">&bull;</span>
%endfor
    <%doc>
%if blog.comments:
    <a href="#comments">${len(blog.comments)} Comments</a>
%else:
    No Comments
%endif
</%doc>
</p>
                  </div>
                  <!-- /.user-block -->
            <h3><b>${blog.title}</b></h3>
        %if blog.status == True:
            <div class="table-responsive">
<table class="table">
<tr id="social">
##<td><a href=""><span class="glyphicon glyphicon-envelope"></span>
##  Email Alerts</a></td>
<td>${self.tweet()}</td>
<td><div class="fb-send" data-href="${request.route_url('blog_view',name=blog.name)}" data-colorscheme="light"></div></td>
<td><div class="fb-share-button" data-href="${request.route_url('blog_view',name=blog.name)}" data-type="button"></div></td>
</tr>
</table>
</div>
        %endif
                  <div class="fr-view">
                        ${literal(blog.body)}
                    </div>
                %if blog.status==True:

                <div class="table-responsive">
<table class="table">
<tr id="social">
##<td><a href=""><span class="glyphicon glyphicon-envelope"></span>
##  Email Alerts</a></td>
<td>${self.tweet()}</td>
<td><div class="fb-send" data-href="${request.route_url('blog_view',name=blog.name)}" data-colorscheme="light"></div></td>
<td><div class="fb-share-button" data-href="${request.route_url('blog_view',name=blog.name)}" data-type="button"></div></td>
</tr>
</table>
</div>
                  <div class="fb-comments" data-href="${request.route_url('blog_view',name=blog.name)}" data-numposts="5"></div>
                          %endif
                </div>
                </div>
            </div>


	</div>
	<div class="col-sm-4">
<div class="box box-info">
    <div class="box-body">

<div class="hidden-sm hidden-xs">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- BlogView Sidebar -->
<ins class="adsbygoogle"
     style="display:inline-block;width:300px;height:600px"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="5248005722"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
	</div>
</div>
</div>
</div>
        </section>
</div><!-- /.ends container -->

<%def name="tweet()">
<a href="https://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</%def>
<%include file="category_sidebar.mako"/>