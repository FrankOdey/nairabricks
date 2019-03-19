<div id="dashboardmenu" class="uk-offcanvas">
<div class="uk-offcanvas-bar">
 <ul class="uk-nav uk-nav-side uk-nav-offcanvas uk-nav-parent-icon" data-uk-nav>
     <li class="uk-nav-header">Dashboard Menu</li>
<li class="uk-parent">
                        <a href="#">Users</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('user_list')}">user List</a></li>
                                <li><a href="${request.route_url('add_group')}">Groups</a></li>
                                <li><a href="${request.route_url('user_log')}">User log</a></li>
                            </ul>
                    </li>
     <%doc>
                    <li class="uk-parent">
                        <a href="#">Blog</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('blog_category_list')}">category List</a></li>

                            </ul>
                    </li>


                <li class="uk-parent">
                        <a href="#">Q&A</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('q_category_list')}">category List</a></li>

                            </ul>
                    </li>
                    </%doc>
                <li class="uk-parent">
                        <a href="#">Listings</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('listing_category_list')}">category List</a></li>
                                <li><a href="${request.route_url('admin_search_listing')}">Unapproved Listings</a></li>
                            </ul>
                    </li>
                    <%doc>
                <li class="uk-parent">
                        <a href="#">Documents</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('add_doc')}">Add</a></li>
                                <li><a href="${request.route_url('list_doc')}">list</a></li>
                            </ul>
                    </li>

     <li class="uk-parent">
                        <a href="#">Local</a>
                            <ul class="uk-nav-side uk-nav-sub">
                                <li><a href="${request.route_url('add_local')}">Add</a></li>
                                <li><a href="${request.route_url('list_citypiccategory')}">City Pics Category</a></li>
                            </ul>
                    </li>
         </%doc>

</ul>
</div>
</div>