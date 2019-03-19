<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>${title} | Nairabricks</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/bootstrap.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript >
        <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/bootstrap.css')}">
    </noscript>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/font-awesome/css/font-awesome.min.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/font-awesome/css/font-awesome.min.css')}">
    </noscript>
  <!-- Ionicons -->
  <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/Ionicons/css/ionicons.min.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/Ionicons/css/ionicons.min.css')}">
    </noscript>
  <!-- Skin -->
  <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/skins/skin-purple.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/skins/skin-purple.css')}">
    </noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/AdminLTE.css')}">

        <link rel="stylesheet" href="${request.static_url('buddy:static/consumer.css')}">
    <link rel="shortcut icon" href="${request.static_url('buddy:static/favicon.ico')}" />

    <style>
        .req{
            color: red;
        }
    </style>
    <%block name="header_tags">
    </%block>
  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<body class="hold-transition skin-purple sidebar-mini">
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="/" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><img src="/static/logomini.png" width="20" alt="logo"/></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><img src="/static/logo.png" class="brand-logo" alt="logo"/></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
            <!-- User Account Menu -->

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
                          <div class="col-xs-4 text-center"><a href="${request.route_url('user_listings', prefix= request.user.prefix)}"></span> Listings</a></div>
                          <div class="col-xs-4 text-center"><a href="${request.route_url('user_blog', prefix= request.user.prefix)}">Blogs</a></div>
                      </div>
                  </li>
         <li><a href="${request.route_url('profile', prefix=request.user.prefix)}"><span class="glyphicon glyphicon-user"></span> Profile</a></li>
                      <li><a href="${request.route_url('favourite_properties',
                      prefix=request.user.prefix)}"><span class="glyphicon glyphicon-heart"></span> Favourites</a></li>
         ##<li><a href="${request.route_url('user_ratings_and_reviews',prefix=request.user.prefix)}"><span class="glyphicon glyphicon-star"></span> Reviews </a></li>

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
          </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel
      <div class="user-panel">
        <div class="pull-left image">
           %if not request.user.photo:
             <img class="img-circle" src="/static/default-picture.jpg" alt="User image">
                    %else:
                    <img class="img-circle" src="${request.storage.url(request.user.photo)}" alt="User image">

                    %endif
        </div>
        <div class="pull-left info">
          <p>${request.user.fullname}</p>

        </div>
      </div>-->
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header">MAIN NAVIGATION</li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-circle-o text-yellow"></i> <span>Account</span></a></li>
          <li><a href="${request.route_url('account-listings')}"><i class="fa fa-circle-o text-yellow"></i> <span>Listings</span></a></li>
          <li><a href="${request.route_url('account-blogs')}"><i class="fa fa-circle-o text-yellow"></i> <span>Blog Posts</span></a></li>
          <li><a href="${request.route_url('my_subscription')}"><i class="fa fa-circle-o text-yellow"></i> <span>Subscription</span></a></li>
          <li><a href="${request.route_url('add_listings')}"><i class="fa fa-circle-o text-yellow"></i> <span>Post Property</span></a></li>
%if request.has_permission('admin'):
     <li class="treeview">
          <a href="#">
            <i class="fa fa-cog"></i>
            <span>Admin</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu" style="display: none;">
              <li><a href="${request.route_url('user_list')}"><i class="fa fa-circle-o text-yellow"></i><span>user List</span></a></li>
          <li><a href="${request.route_url('add_group')}"><i class="fa fa-circle-o text-yellow"></i><span>Groups</span></a></li>
              <li><a href="${request.route_url('user_log')}"><i class="fa fa-circle-o text-yellow"></i><span>User log</span></a></li>
              <li><a href="${request.route_url('blog_category_list')}"><i class="fa fa-circle-o text-yellow"></i><span>Blog category</span></a></li>
              <li><a href="${request.route_url('draft_list')}"><i class="fa fa-circle-o text-yellow"></i><span>Blog drafts</span></a></li>
              <li><a href="${request.route_url('listing_category_list')}"><i class="fa fa-circle-o text-yellow"></i><span>Listing category</span></a></li>
              <li><a href="${request.route_url('admin_search_listing')}"><i class="fa fa-circle-o text-yellow"></i><span>Unapproved Listings</span></a></li>
          <li><a href="${request.route_url('list_state')}"><i class="fa fa-circle-o text-yellow"></i><span>States</span></a></li>
              <li><a href="${request.route_url('add_frontpage_picture')}"><i class="fa fa-circle-o text-yellow"></i><span>Background Pix</span></a></li>
              <li><a href="${request.route_url('list_plans')}"><i class="fa fa-circle-o text-yellow"></i><span>Subscription Plans</span></a></li>
          </ul>
        </li>
%endif

      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>
<%block name="flash_message">
${self.flash_messages()}
    </%block>
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">


${next.body()}

    <!-- /.content -->
  </div>


</div>
<!-- ./wrapper -->

<!-- jQuery 3 -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery.min.js')}"></script>
<!-- jQuery UI 1.11.4 -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery-ui.min.js')}"></script>
<!-- Bootstrap 3.3.7 -->
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

<!-- Slimscroll -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery-slimscroll/jquery.slimscroll.min.js')}"></script>
<!-- FastClick -->
##<script src="${request.static_url('buddy:static/dashboard-asset/fastclick/lib/fastclick.js')}"></script>
<!-- AdminLTE App -->
<script src="${request.static_url('buddy:static/dashboard-asset/js/adminlte.min.js')}" ></script>
<script src="${request.static_url('buddy:static/jqueryform.js')}"></script>

<script src="${request.static_url('buddy:static/bootstrap/js/bootstrap-multiselect.js')}" ></script>
<script src="${request.static_url('buddy:static/jquery.validate.min.js')}" ></script>
<script src="${request.static_url('buddy:static/priceformat.js')}" ></script>
<script src="${request.static_url('buddy:static/consumer.js')}" ></script>

<%block name="script_tags">
</%block>
<%def name="flash_messages()">
		% if request.session.peek_flash():

		<% flash = request.session.pop_flash() %>
		% for message in flash:
<div class="container">
     <div class="row">
         <div class="col-md-6 col-md-offset-3">
             <div class="alert alert-${message.split(';')[0]} alert-dismissable">
	 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>

				${message.split(";")[1]}

		</div>
         </div>
     </div>
    </div>


		% endfor

	% endif
</%def>
</body>
</html>
