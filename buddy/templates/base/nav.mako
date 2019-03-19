<header class="main-header" id="frontendHeader">
    <nav class="navbar navbar-static-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
            <i class="fa fa-bars"></i>
          </button>
            <a href="/" class="logo"><img src="/static/logo.png" class="brand-logo" alt="logo"/></a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse pull-left" id="navbar-collapse">
          <ul class="nav navbar-nav">
               ## <li><a href="/">Home</a></li>
                       ##<li class="${'active' if find else ''}"><a href="${request.route_url('all_property_listing')}">Find Homes</a></li>
                       <li><a href="${request.route_url('search_properties')}?type=For+Sale">For Sale</a></li>

    	               <li><a href="${request.route_url('search_properties')}?type=For+Rent">For Rent</a></li>
                        <li><a href="${request.route_url('search_properties')}?type=Short+let">Short Let</a></li>
                <li><a href="${request.route_url('blog_list')}">Advice</a></li>
                <li><a href="${request.route_url('pricing')}">Pricing</a></li>
                <li><a href="${request.route_url('add_listings')}"> Post Property</a></li>
                <li><a href="${request.route_url('account')}">Dashboard</a></li>
          </ul>
        </div>
        <!-- /.navbar-collapse -->
        <!-- Navbar Right Menu -->
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
              <%doc>
            <!-- Messages: style can be found in dropdown.less-->
            <li class="dropdown messages-menu">
              <!-- Menu toggle button -->
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-envelope-o"></i>
                <span class="label label-success">4</span>
              </a>
              <ul class="dropdown-menu">
                <li class="header">You have 4 messages</li>
                <li>
                  <!-- inner menu: contains the messages -->
                  <ul class="menu">
                    <li><!-- start message -->
                      <a href="#">
                        <div class="pull-left">
                          <!-- User Image -->
                          <img src="../../dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                        </div>
                        <!-- Message title and timestamp -->
                        <h4>
                          Support Team
                          <small><i class="fa fa-clock-o"></i> 5 mins</small>
                        </h4>
                        <!-- The message -->
                        <p>Why not buy a new awesome theme?</p>
                      </a>
                    </li>
                    <!-- end message -->
                  </ul>
                  <!-- /.menu -->
                </li>
                <li class="footer"><a href="#">See All Messages</a></li>
              </ul>
            </li>
            <!-- /.messages-menu -->

            <!-- Notifications Menu -->
            <li class="dropdown notifications-menu">
              <!-- Menu toggle button -->
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-bell-o"></i>
                <span class="label label-warning">10</span>
              </a>
              <ul class="dropdown-menu">
                <li class="header">You have 10 notifications</li>
                <li>
                  <!-- Inner Menu: contains the notifications -->
                  <ul class="menu">
                    <li><!-- start notification -->
                      <a href="#">
                        <i class="fa fa-users text-aqua"></i> 5 new members joined today
                      </a>
                    </li>
                    <!-- end notification -->
                  </ul>
                </li>
                <li class="footer"><a href="#">View all</a></li>
              </ul>
            </li>
            <!-- Tasks Menu -->
            <li class="dropdown tasks-menu">
              <!-- Menu Toggle Button -->
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-flag-o"></i>
                <span class="label label-danger">9</span>
              </a>
              <ul class="dropdown-menu">
                <li class="header">You have 9 tasks</li>
                <li>
                  <!-- Inner menu: contains the tasks -->
                  <ul class="menu">
                    <li><!-- Task item -->
                      <a href="#">
                        <!-- Task title and progress text -->
                        <h3>
                          Design some buttons
                          <small class="pull-right">20%</small>
                        </h3>
                        <!-- The progress bar -->
                        <div class="progress xs">
                          <!-- Change the css width attribute to simulate progress -->
                          <div class="progress-bar progress-bar-aqua" style="width: 20%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                            <span class="sr-only">20% Complete</span>
                          </div>
                        </div>
                      </a>
                    </li>
                    <!-- end task item -->
                  </ul>
                </li>
                <li class="footer">
                  <a href="#">View all tasks</a>
                </li>
              </ul>
            </li>
             </%doc>
            <!-- User Account Menu -->
            %if request.user:
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle"
                    data-toggle="dropdown" aria-expanded="false">

                %if not request.user.photo:
             <img class="user-image" src="/static/default-picture.jpg">
                    %else:
                    <img class="user-image" src="${request.storage.url(request.user.photo)}">

                    %endif
                <span class="hidden-xs">${request.user.fullname}</span>
                <span class="caret" style="color:#fff"></span>
            </a>
              <ul class="dropdown-menu">
                  <li class="user-header">
                      %if not request.user.photo:
             <img class="img-circle" src="/static/default-picture.jpg">
                    %else:
                    <img class="img-circle" src="${request.storage.url(request.user.photo)}">

                    %endif
                      <p>${request.user.fullname}</p>
                     <span style="color:#fff">AccountID: ${request.user.serial}</span>
                  </li>
                  <li class="user-body">
                      <div class="row">
                          <div class="col-xs-4 text-center"><a href="${request.route_url('account')}">Account</a></div>
                          <div class="col-xs-4 text-center"><a href="${request.route_url('account-listings', prefix= request.user.prefix)}"></span> Listings</a></div>
                          <div class="col-xs-4 text-center"><a href="${request.route_url('account-blogs', prefix= request.user.prefix)}">Blogs</a></div>
                      </div>
                  </li>
         <li><a href="${request.route_url('profile', prefix=request.user.prefix)}"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
                      <li><a href="${request.route_url('account-listings')}"><span class="glyphicon glyphicon-heart"></span> Favourites</a></li>
         <%doc>
                  <li><a href="${request.route_url('inbox',id=request.user.id)}"><span class="glyphicon glyphicon-envelope"></span> Messages
         %if request.user.messages:
                            %if request.user.total_unseen_messages>0:

                            <span class="badge bage-warning">${request.user.total_unseen_messages}</span>
                                %endif
                        %endif

         </a></li>
         </%doc>
        ## <li><a href="${request.route_url('user_questions', prefix= request.user.prefix)}"><span class="glyphicon glyphicon-question-sign"></span> My Questions</a></li>
        ## <li><a href="${request.route_url('user_answers', prefix= request.user.prefix)}"><span class="glyphicon glyphicon-list-alt"></span> My Answers</a></li>
         ##<li><a href="${request.route_url('user_ratings_and_reviews',prefix=request.user.prefix)}"><span class="glyphicon glyphicon-star"></span> Reviews </a></li>
        ##<li><a href="${request.route_url('add_listings')}"><span class="glyphicon glyphicon-pencil"></span> Post Property</a></li>
      ##<li><a href="${request.route_url('ask_questions')}"><span class="glyphicon glyphicon-pencil"></span> Ask Question</a></li>
                  <li class="user-footer">
                  <div class="pull-left">
                    <a href="${request.route_url('user_edit')}" class="btn btn-default btn-flat"><span class="glyphicon glyphicon-cog"></span> Edit profile</a>
                  </div>
                  <div class="pull-right">
                    <a href="${request.route_url('logout')}" class="btn btn-default btn-flat"><span class="glyphicon glyphicon-log-out"></span> logout</a>
                  </div>
                </li>
         <li></li>
         <li></li>
     </ul>

          </li>
    %else:
        <li><a href="${request.route_url('reg')}">Signup</a></li>
        <li><a href="${request.route_url('login')}">Signin</a></li>
    %endif
             %if blog_nav_cat:
                 <li><a href="#" data-toggle="control-sidebar"><i class="fa fa-search fa-2x"></i></a></li>
             %endif
          </ul>
        </div>
        <!-- /.navbar-custom-menu -->
      </div>
      <!-- /.container-fluid -->
    </nav>
  </header>