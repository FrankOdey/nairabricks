<%!
    import string, os
    %>
<%block name="blog_categories">
<aside class="control-sidebar control-sidebar-dark" id="blog-category-sidebar">
    <div class="content">
   <h4>BLOG CATEGORIES</h4>
                <div id="category-filter" role="tablist" aria-multiselectable="true">
 <ul class="list-unstyled" >
%for category in blog_nav_cat:

%if category.children:

         <li class="blog-category-filter"> <a style="color:#fff" data-toggle="collapse" data-parent="#category-filter"
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
  </aside>
</%block>
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