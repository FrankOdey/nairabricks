<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<%block name="script_tags">
    <!-- FLOT CHARTS -->
<script src="${request.static_url('buddy:static/dashboard-asset/Flot/jquery.flot.js')}"></script>
<!-- FLOT RESIZE PLUGIN - allows the chart to redraw when the window is resized -->
<script src="${request.static_url('buddy:static/dashboard-asset/Flot/jquery.flot.resize.js')}"></script>
        <!-- FLOT CATEGORIES PLUGIN - Used to draw bar charts -->
<script src="${request.static_url('buddy:static/dashboard-asset/Flot/jquery.flot.categories.js')}"></script>
    <script>
/*
     * BAR CHART
     * ---------
     */

    var bar_data = {
      data : ${[[i.serial,i.total_views] for i in listings if listings]},
      color: '#3c8dbc'
    };
    $.plot('#bar-chart', [bar_data], {
      grid  : {
        borderWidth: 1,
        borderColor: '#f3f3f3',
        tickColor  : '#f3f3f3'
      },
      series: {
        bars: {
          show    : true,
          barWidth: 0.5,
          align   : 'center'
        }
      },
      xaxis : {
        mode      : 'categories',
        tickLength: 0
      }
    })
    /* END BAR CHART */
    </script>
</%block>
<section class="content-header">
      <h1>
        Dashboard
          <small>Control panel</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href=""><i class="fa fa-dashboard"></i> Dashboard</a></li>
      </ol>
    </section>
<section class="content">
    <div class="row" style="display: none">
        <div class="col-md-12">
            <div class="callout callout-info">
                <a href="#" class="btn btn-pink btn-flat">Feature your listings and blog posts right now</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-danger">
                        <p>Earn a <span class="label label-info"> silver</span> subscription package when you refer someone to nairabricks</p>
                        <h4>Details</h4>
                        <p>The first of your referrals to verify their profile earns you a silver subscription.
                        <span class="bg-black"> Any referral that post a property, earns you 1000 naira per property posted.
                            This money is usable in this platform. You can use it to pay for banner ads on our website</span></p>
                <p>Here is your referral link: <code>${reflink}</code></p>
                <p><a href="#" data-toggle="modal" data-target="#modal-info">Verify your profile now</a> and your listings will be listed directly without review</p>
                    </div>
        </div>
    </div>
    <div class="modal modal-info fade" id="modal-info" style="display: none;">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">×</span></button>
                <h4 class="modal-title">How to verify your profile</h4>
              </div>
              <div class="modal-body">
                <p>Profile verification is very important. When your profile is verified,
                    you'll list properties and publish directly without the property being put under review</p>
                  <p>To verify your profile, you need to send the following documents to info@nairabricks.com</p>
                  <ul>
                      <li>Certificate of Incorporation or Business name registration certificate</li>
                      <li>Any one of the following:
                          <ul>
                              <li>Recent utility bill with your nairabricks account address on it</li>
                              <li>Most recent tax clearance(not more than 12 months old</li>
                          </ul>
                      </li>
                  </ul>
                  <p>Thank you</p>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-outline" data-dismiss="modal">Ok, Good</button>
              </div>
            </div>
            <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
        </div>
<div class="row">
    <div class="col-lg-3">
        <div class="small-box bg-aqua">
            <div class="inner">
              <h3>${request.user.total_listings}</h3>

              <p>My Listings</p>
            </div>
            <div class="icon">
              <i class="fa fa-building"></i>
            </div>
            <a href="${request.route_url('account-listings')}" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
          </div>
    </div>
    <div class="col-lg-3">
        <div class="small-box bg-green">
            <div class="inner">
              <h3>${request.user.total_blogs}</h3>

              <p>Blog Posts</p>
            </div>
            <div class="icon">
              <i class="fa fa-book"></i>
            </div>
            <a href="${request.route_url('account-blogs')}" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
          </div>
    </div>
    <div class="col-lg-3">
        <div class="small-box bg-red">
            <div class="inner">
              <h3>${len(user.children)}</h3>

              <p>Referrals</p>
            </div>
            <div class="icon">
              <i class="fa fa-users"></i>
            </div>
            <a href="${request.route_url('account-referrals')}" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
          </div>
    </div>
    <div class="col-lg-3">
        <div class="small-box bg-yellow">
            <div class="inner">
             %if request.user.active_subscription:
                    <h3>${request.user.active_subscription[0].plan.name}</h3>
                    %else:
                    <h3>Free Plan</h3>
                    %endif

              <p>Subscription Plan</p>
            </div>
            <div class="icon">
              <i class="fa fa-money"></i>
            </div>
            <a href="${request.route_url('my_subscription')}" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
          </div>
    </div>
</div>
<div class="row" style="display:none">
    <div class="col-md-6">
         <!-- Bar chart -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <i class="fa fa-bar-chart-o"></i>

              <h3 class="box-title">Total views for your listings</h3>

              <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
                </button>
                <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
              </div>
            </div>
            <div class="box-body">
              <div id="bar-chart" style="height: 300px;"></div>
            </div>
            <!-- /.box-body-->
          </div>
          <!-- /.box -->
    </div>
</div>
</section>


