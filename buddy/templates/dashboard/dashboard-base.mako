<%inherit file="buddy:templates/base/layout.mako"/>
<%block name="header_tags">
    ${parent.header_tags()}
<style>
    body {
       background: #fff;
    }
</style>
</%block>

<div class="container-fluid">

    <div class="row">
        <div class="col-md-2">

            <ul class="nav nav-list">
                      <li><a href="${request.route_url('user_list')}">user List</a></li>
                                <li><a href="${request.route_url('add_group')}">Groups</a></li>
                                <li><a href="${request.route_url('user_log')}">User log</a></li>
                                <li><a href="${request.route_url('blog_category_list')}">Blog category</a></li>
                                <li><a href="${request.route_url('draft_list')}">Blog drafts</a></li>
                                <li><a href="${request.route_url('listing_category_list')}">Listing category</a></li>
                                <li><a href="${request.route_url('admin_search_listing')}">Unapproved Listings</a></li>
                                <li><a href="${request.route_url('list_state')}">States</a></li>
                                <li><a href="${request.route_url('add_frontpage_picture')}">Background Pix</a></li>
                                 <li><a href="${request.route_url('list_plans')}">Subscription Plans</a></li>
</ul>
</div>
        <div class="col-md-10">

        ${next.body()}

        </div>
         </div>
    </div>


