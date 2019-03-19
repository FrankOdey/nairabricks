<div class="media" style="background:#bdf4e2; padding:5px">
  <a class="pull-left" href="#">
      %if listing.user.photo:
          <img class="media-object userdetails-img" src="${request.storage.url(listing.user.photo)}" alt="${listing.user.fullname} photo">
     %else:
    <img class="media-object userdetails-img" src="/static/default-picture.jpg" alt="${listing.user.fullname} photo">
           %endif
  </a>

  <div class="media-body">
<div class="media-heading"> <a href="${request.route_url('profile', prefix=listing.user.prefix)}">${listing.user.fullname.title()}</a>
        %if listing.user.is_verified:
        <img src="/static/verified.png" width="20" data-toggle="tooltip" data-placement="bottom"
             title="Verified Professional" alt="verified professional logo"/>
    %endif
</div>
%if listing.user.user_type:
  ${listing.user.user_type.name}
%endif
<br>
##%if listing.user.user_type and listing.user.user_type.name.lower() !='other/just looking':
##<span class="label label-danger">PRO</span>
##%endif
%if listing.user.mobile:
     <a href="tel:${listing.user.mobile}" class="uk-button uk-button-primary uk-button-mini hidden-md hidden-lg">Call Mobile</a>
    <a href="tel:${listing.user.mobile}" class=" hidden-sm hidden-xs"><i class="uk-icon uk-icon-mobile"></i> ${listing.user.mobile}<br></a>
%endif
%if listing.user.phone:
     <a href="tel:${listing.user.phone}" class="uk-button uk-button-primary uk-button-mini hidden-md hidden-lg">Call Office</a>
    <a href="tel:${listing.user.phone}" class=" hidden-sm hidden-xs"><i class="uk-icon uk-icon-phone"></i> ${listing.user.mobile}</a>
%endif
  </div>
</div>