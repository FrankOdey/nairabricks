<div class="category-nav">
<nav class="navbar navbar-inverse" role="navigation" style="margin-top:-20px;">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse-2">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
<span class="navbar-brand visible-xs">Categories</span>
    </div>

<div class="collapse navbar-collapse" id="navbar-collapse-2">
 <ul class="nav navbar-nav">
<li><a href="${request.route_url('question_list')}">All Topics</a></li>
%for category in q_nav_cat[:3]:
%if category.children:
	<li class="dropdown">
          <a href="${request.route_url('question_category_filter', filter=category.name)}" class="dropdown-toggle" data-toggle="dropdown" data-target="#">${category.name.capitalize()}<b class="caret"></b></a>
	<ul class="dropdown-menu">

	%for child in category.children:
		<li><a href="${request.route_url('question_category_filter', filter=child.name)}">${child.name.capitalize()}</a></li>
	%endfor
		</ul>
	</li>
%endif
%endfor
<li><a href="#CategoryNav" data-uk-offcanvas>More<i class="caret"></i></a></li>

</ul>
</div>
</nav>
<%include file="category-nav.mako"/>
</div>
