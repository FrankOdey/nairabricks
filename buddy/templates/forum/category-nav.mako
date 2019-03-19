<div id="CategoryNav" class="uk-offcanvas">
<div class="uk-offcanvas-bar">
 <ul class="uk-nav uk-nav-side uk-nav-offcanvas uk-nav-parent-icon" data-uk-nav>
     <li class="uk-nav-header">Question Categories</li>
<li><a href="${request.route_url('question_list')}">All Topics</a></li>
%for category in q_nav_cat:
%if category.children:
	<li class="uk-parent">
          <a href="#">${category.name.capitalize()}</a>
	<ul class="uk-nav-sub">
	%for child in category.children:
		<li><a href="${request.route_url('question_category_filter', filter=child.name)}">${child.name.capitalize()}(${len(child.questions)})</a></li>
	%endfor
		</ul>
	</li>
%endif
%endfor


</ul>
</div>
</div>