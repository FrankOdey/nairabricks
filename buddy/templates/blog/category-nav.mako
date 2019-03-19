<%namespace file="buddy:templates/blog/list.mako" import="childBlogCount"/>
<div id="CategoryNav" class="uk-offcanvas" >
<div class="uk-offcanvas-bar">
 <ul class="uk-nav uk-nav-side uk-nav-offcanvas uk-nav-parent-icon" data-uk-nav>
     <li class="uk-nav-header">BLOG CATEGORIES</li>
<li><a href="${request.route_url('blog_list')}">All Topics</a></li>
%for category in blog_nav_cat:
%if category.children:
	<li class="uk-parent">
          <a href="#">${category.name.capitalize()} (${childBlogCount(category)})</a>
	<ul class="uk-nav-sub">
	%for child in category.children:
		<li><a href="${request.route_url('blog_category_filter', filter=child.name)}">${child.name.capitalize()}(${len(child.blogs)})</a></li>
	%endfor
		</ul>
	</li>
%endif
%endfor


</ul>
</div>
</div>