<%namespace file="buddy:templates/blog/list.mako" import="childBlogCount"/>

<div class="category-nav">
<nav class="navbar navbar-default" role="navigation" style="margin-top:-5px;">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse-2">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>

<div class="collapse navbar-collapse" id="navbar-collapse-2">
 <ul class="nav navbar-nav">
<li><a href="${request.route_url('blog_list')}">Home</a></li>
%for category in blog_nav_cat:
%if category.children:
	<li class="dropdown">
          <a href="${request.route_url('blog_category_filter',id=category.id)}" class="dropdown-toggle" data-toggle="dropdown" data-target="#">${category.name.capitalize()}(${childBlogCount(category)})<b class="caret"></b></a>
	<ul class="dropdown-menu">

	%for child in category.children:
		<li><a href="${request.route_url('blog_category_filter',id=child.id)}">${child.name.capitalize()} (${len(child.blogs)})</a></li>
	%endfor
		</ul>
	</li>
%endif
%endfor
##<li><a href="#CategoryNav" data-uk-offcanvas>More<i class="caret"></i></a></li>

</ul>
</div>
</nav>
##<%include file="category-nav.mako"/>
</div>