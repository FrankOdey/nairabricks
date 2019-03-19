<%inherit file = "buddy:templates/user/userbase.mako"/>
<section>
    <div class="row">
        <div class="col-md-12">
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
                    <li>
                        %if user.company_logo:
                        <img style="max-height:250px" src="${request.storage.url(user.company_logo)}"/>
                    %endif
                    </li>
                </ul>
                <strong><i class="margin-r-5"></i> Company</strong>
                <p class="text-muted">
                    %if user.company_name:
                    ${user.company_name}
                        %else:
                        Not updated
                    %endif
                </p>
                <ul class="list-inline">
                    %if user.mobile:
     <li><a href="tel:${user.mobile}" class="btn btn-pink btn-flat btn-xs hidden-md hidden-lg">Call Mobile</a></li>
    <li><a href="tel:${user.mobile}" class=" hidden-sm hidden-xs"><i class="fa fa-mobile"></i> ${user.mobile}<br></a></li>
%endif
%if user.phone:
     <li><a href="tel:${user.phone}" class="btn btn-pink btn-flat btn-xs  hidden-md hidden-lg">Call Office</a></li>
    <li><a href="tel:${user.phone}" class=" hidden-sm hidden-xs"><i class="uk-icon uk-icon-phone"></i> ${user.mobile}</a></li>
%endif
                </ul>
              <strong><i class="margin-r-5"></i> About</strong>

              <p class="text-muted">
               %if user.note:
               ${user.note|n}
                   %else:
                   This user have not written anything about them
               %endif
              </p>

              <hr>

              <strong><i class="fa fa-map-marker margin-r-5"></i> Location</strong>

              <p class="text-muted">
                  %if user.state:
                  ${user.state.name}
                      %else:
                      Not updated
                  %endif
              </p>

              <hr>

            </div>
            <!-- /.box-body -->
          </div>
        </div>
        %if request.has_permission('super_admin'):
            <h4>Admin Area</h4>
            <div class="row">

                <div class="col-md-4">
                    <form action="${request.route_url('promo_sub', id=user.id)}" method="post">
                        <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
                        <div class="form-group">
                        <label>Plan</label>
                        <select name="plan" class="form-control">
                                    <option value="">Select plan</option>
                                    <option value="1">Basic</option>
                                    <option value="2">Silver</option>
                                    <option value="3">Gold</option>
                        </select>
                        </div>
                    <button name="submit" class="btn btn-flat btn-pink">Submit</button>
                    </form>
                </div>
                <div class="col-md-8">
                    <a href="${request.route_url('verify_user',prefix=user.prefix)}" class="btn btn-warning "> Verify</a>
        <a href="${request.route_url('deny_verified',prefix=user.prefix)}" class="btn btn-warning ">Deny Verified</a>

                </div>
            </div>
        %endif
    </div>
</section>
