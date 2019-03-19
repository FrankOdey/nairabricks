<%inherit file = "buddy:templates/base/layout.mako"/>
<%!
	from webhelpers.html import literal
%>
<%block name="header_tags">
<style>
.complete{
    display:none;
}
.moretext, .lesstext{
    background:lightblue;
    color:navy;
    font-size:13px;
    padding:3px;
    cursor:pointer;

}
</style>
</%block>
<%block name="script_tags">
    <script>
        $(".moretext").click(function(){
            $(this).hide();
            $("#full").show();
            $('#truncated').hide();
            $(".lesstext").show();
        });
        $(".lesstext").click(function(){
                    $(this).hide();
                    $("#full").hide();
                    $("#truncated").show();
                    $(".moretext").show();
                    $(".lesstext").hide();
                });
    </script>
</%block>

<div class="container">
    <div class="content">
    <div class="row">
        <div class="col-md-8">
            <div class="box box-widget widget-user">
            %if user.cover_photo:

                                <%
            u=request.storage.url(user.cover_photo)
            u=u.replace('\\','/')
          %>
                                    <!-- Add the bg color to the header using any of the bg-* classes -->
            <div class="widget-user-header bg-black" style="background: url('${request.storage.url(u)}') center center;">
                                    %else:
                                    <!-- Add the bg color to the header using any of the bg-* classes -->
            <div class="widget-user-header bg-black" style="background: url('/static/bg.jpg') center center;">
                                    %endif
              <h3 class="widget-user-username">${user.fullname}</h3>

                    %if user.company_name:
                    <h4> ${user.company_name}</h4>
                    %endif

              <h5 class="widget-user-desc">
                   %if user.user_type:
                      ${user.user_type.name}
                      %else:
                      User Profession Unknown
                  %endif
              </h5>
            </div>
            <div class="widget-user-image">
              %if not user.photo:
                <img class="profile-user-img img-responsive img-circle" src="/static/maleavater.png" alt="User profile picture">
                    %else:
                    <img class="profile-user-img img-responsive img-circle" src="${request.storage.url(user.photo)}" alt="User profile picture">
                %endif
            </div>
            <div class="box-footer">
              <div class="row">
                <div class="col-sm-4 border-right">
                  <div class="description-block">
                    <h5 class="description-header">${user.total_listings}</h5>
                    <span class="description-text">TOTAL LISTINGS</span>
                  </div>
                  <!-- /.description-block -->
                </div>
                <!-- /.col -->
                  <div class="col-sm-4">
                  <div class="description-block">
                    <h5 class="description-header">${total_sales}</h5>
                    <span class="description-text">PAST SALES</span>
                  </div>
                  <!-- /.description-block -->
                </div>
                <!-- /.col -->
                <div class="col-sm-4 border-right">
                  <div class="description-block">
                    <h5 class="description-header">${user.total_blogs}</h5>
                    <span class="description-text">BLOG POSTS</span>
                  </div>
                  <!-- /.description-block -->
                </div>
                <!-- /.col -->

              </div>

              <!-- /.row -->
            </div>
          </div>
             <!-- About Me Box -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">About Me</h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body">
                <ul class="list-inline">
                   <li> <a href="${request.route_url('user_listings', prefix= user.prefix)}" class="btn btn-flat btn-pink">View Listings</a></li>
                    <li><a href="${request.route_url('user_blog', prefix= user.prefix)}" class="btn btn-flat btn-pink">View Blog Posts</a></li>
                </ul>
                <strong><i class="margin-r-5"></i> Company</strong>
                <p class="text-muted">
                    %if user.company_name:
                    ${user.company_name}
                        %else:
                        Not updated
                    %endif
                </p>
              <strong><i class="margin-r-5"></i> About</strong>

              <p class="text-muted">
               %if user.note:
               ${user.note}
                   %else:
                   You have not written anything about you
               %endif
              </p>

              <hr>

              <strong><i class="fa fa-map-marker margin-r-5"></i> Location</strong>

              <p class="text-muted">
                  %if user.state:
                  ${user.state.name}
                      %else:
                      Not known
                  %endif
              </p>

              <hr>

            </div>
            <!-- /.box-body -->
          </div>
        </div>
        <div class="col-md-4">
        </div>

    </div>
</div>
    </div>
