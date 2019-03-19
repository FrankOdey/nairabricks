
<div id="tm-offcanvas" class="uk-offcanvas">

            <div class="uk-offcanvas-bar">
<%doc>
                <ul class="uk-nav uk-nav-offcanvas uk-nav-parent-icon" data-uk-nav>
					<li class="uk-nav-header">Menu</li>
                    <li><a href="/">Home</a></li>
                    <li class="${'uk-active' if find else ''}"><a href="${request.route_url('all_property_listing')}">
                    <i class="uk-icon-home uk-icon-small"></i> Find homes</a></li>
                    ##<li class="${'uk-active' if buy else ''}"><a href="${request.route_url('buy')}">Buy</a></li>
	                ##<li class="${'uk-active' if rent else ''}"><a href="${request.route_url('rent')}">Rent</a></li>
                    <li class="uk-parent"><a href="#"><i class="uk-icon-newspaper-o uk-icon-small"></i> Advice</a>
                        <ul class="uk-nav-sub">
                            ##<li><a href="${request.route_url('voices')}">Voices</a></li>
                                    <li><a href ="${request.route_url('question_list')}"><i class="uk-icon-question-circle uk-icon-small"></i> Q&A</a></li>
                                    <li><a href="${request.route_url('blog_list')}"><i class="uk-icon-book uk-icon-small"></i> Blogs</a></li>
                                    <li class="divider"></li>
		                            <li><a href="${request.route_url('ask_questions')}"><i class="uk-icon-pencil-square-o uk-icon-small"></i> Ask A Question</a></li>
		                            <li><a href="${request.route_url('add_blog')}"><i class="uk-icon-pencil uk-icon-small"></i> Write A Blog Post</a></li>
                        </ul>
                    </li>
					<li><a href="${request.route_url('list_local')}"><i class="uk-icon-building-o uk-icon-small"></i> City Guide</a></li>
	                ##<li><a href="">Mortgages</a></li>
	                <li><a href="${request.route_url('add_listings')}"><i class="uk-icon-plus-square uk-icon-small"></i> Post Properties</a></li>
                     %if request.has_permission('admin'):
					<li><a href="${request.route_url('dashboard')}"><i class="uk-icon-dashboard uk-icon-small"></i> Dashboard</a></li>
                         %endif
                </ul>
</%doc>
            </div>

        </div>