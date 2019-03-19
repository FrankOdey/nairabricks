<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>
<%!
	from webhelpers.html import literal
%>

<div class="row">
    <div class="col-sm-12">

       ## <ul class="nav nav-tabs bg-success " role="tablist">
##<li><a href="#property-details" >Property Details</a></li>
##  <li><a href="#agent-details" >Contact Agent</a></li>
 ## <li><a href="#city-info" >City Guide</a></li>
##</ul>
        <div id="Editinfo" class="alert alert-info alert-dismissible fade in" role="alert" style="display: none">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
            %if listing.listing_type.lower()=='for sale':
                <p>Marked as Sold</p>
            %else:
                <p>Marked as Rented</p>
            %endif
            </div>
    </div>
    </div>


<div class="row">
    <div class="col-sm-8" id="property-detail-address">
       <b> <span class="glyphicon glyphicon-map-marker"></span>
    %if listing.show_address:
        ${listing.address}</b>
%else:
        Call agent for addresss</b>
%endif
</div>
    <div class="col-sm-4">
    <b>Listing#: ${listing.serial}</b>
    </div>
    </div>
<div class="row" style="margin-top: 10px">
    <div class="col-sm-8">

    </div>
    <div class="col-sm-4 text-right" style="color: #9f0e8e;">
%if listing.price_available:
<h4><span class="price"> ${listing.price}</span></h4>
%if listing.listing_type.lower()=='for rent':
<small style="font-size:14px"><i>yearly rent</i></small>
%endif
    %if listing.listing_type.lower()=='short let':
<small style="font-size:14px"><i>short let</i></small>
%endif
%else:
<small style="font-size:14px">Contact agent for price</small>
%endif
    </div>


  </div>
<div class="row">
<div class="col-sm-12" style="padding: 0px">
<%include file="slideshow.mako"/>
</div>
</div>
<div class="row">
    <div class="col-md-12">
         ${self.controls(listing)}
           <div class="table-responsive">
<table class="table">
<tr id="social">
##<td><a href=""><span class="glyphicon glyphicon-envelope"></span>
##  Email Alerts</a></td>
<td>${self.tweet()}</td>
<td><div class="fb-send" data-href="${request.route_url('property_view',name=listing.name)}" data-colorscheme="light"></div></td>
<td><div class="fb-share-button" data-href="${request.route_url('property_view',name=listing.name)}" data-type="button"></div></td>
</tr>
</table>
</div>
    %if request.has_permission('admin'):
<small class="text-info">Total property views ${listing.total_view}</small>
        %endif

<hr>
    <h4>Property Description</h4>
	${literal(listing.body.replace('\n',"<br>"))}
    <hr>

<small> Advertisement </small>

<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-format="fluid"
     data-ad-layout="image-side"
     data-ad-layout-key="-fg+5r+6l-ft+4e"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="9242329153"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
<hr>
    <h4>Property Details</h4>
<%include file="property_attributes.mako"/>
<%include file="features_attributes.mako"/>
<hr>

</div>
</div>
    <%doc>
<div id="city-info">
<div class="title">City Guide</div>
%if locality:
<%include file="cityslide.mako"/>
%if not locality.rating:
    This city has no ratings. Please <a href="${request.route_url('rate_local',name=locality.city_name)}">rate</a> this area now to increase buyers interest
%endif

%else:
   <p> Your city is not in our list of cities. <a href="">Request</a> for the creation of this city now so you can rate it and increase buyers \
    interest.</p>
%endif
</%doc>

    %if listing.hospital or listing.school or listing.bank or listing.market:
        <div class="row">
        <div class="col-sm-12">
        <div class="panel panel-default">
        <div class="panel-body">
            <h4>Distances from key facilities</h4>
<table class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
    <th>Facility</th>
    <th>Distance</th>
    </tr>
    </thead>
    <tbody>
    <tr>
    <td>Hospital</td>
        <td>
    %if listing.hospital=='6':
        more than 5km
    %else:
    Less than ${listing.hospital}km
    %endif
        </td>
    </tr>
    <tr>
    <td>Bank</td>
        <td>
      %if listing.bank=='6':
        more than 5km
    %else:
    Less than ${listing.bank}km
    %endif
        </td>
    </tr>
    <tr>
    <td>Market</td>
        <td>
    %if listing.market=='6':
        more than 5km
    %else:
    Less than ${listing.market}km
    %endif
        </td>
    </tr>
    <tr>
    <td>School</td>
        <td>
            %if listing.school=='6':
        more than 5km
    %else:
    Less than ${listing.school}km
    %endif
        </td>
    </tr>
    </tbody>
</table>

        </div>
        </div>
        </div>
        </div>
%endif


<%def name="tweet()">
<a href="https://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</%def>
<%def name="controls(listing)">
<p id="message-info" class="label label-info"></p><br>
    <div class="btn-group">
    %if request.user:
         <button class="btn btn-warning make-favourites" data-value=${listing.id}
              data-positive="${1 if listing in request.user.favourites else 0}" data-toggle="tooltip" title="${'Saved' if listing in request.user.favourites else 'Save'}">
<span class="${'glyphicon glyphicon-heart-empty' if listing in request.user.favourites else 'glyphicon glyphicon-heart'}"></span> ${'Saved' if listing in request.user.favourites else 'Save'}</button>

    %endif

        %if request.has_permission('edit'):
        <a href="#editLanding"
            data-toggle="modal" data-target="#editLanding"
             class="btn btn-pink">
            <span class="glyphicon glyphicon-pencil"></span> Update </a>
            <div class="modal fade" id="editLanding" tabindex="-1" role="dialog" aria-labelledby="editLandingLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="editLandingLabel">Edit Listing</h4>
      </div>
      <div class="modal-body">
            %if not listing.declined:
                <div class="row">
                    <div class="col-md-6">
                %if not listing.sold_price:
                    %if listing.listing_type.lower()=="for sale":
                    <a class="btn btn-pink sold" data-id="${listing.id}">Mark as sold</a>
                    %else:
                    <a class="btn btn-danger sold" data-id="${listing.id}">Mark as rented</a>
                    %endif
                    <form id="soldform" style="display:none">
                    <div class="form-group">
                    <label class="control-label">
                        %if listing.listing_type.lower()=="for sale":
                            Price Sold
                            %else:
                            Price Rented
                        %endif
                        </label>
                        <input name="price" type="text" id="price" min="3" class="form-control price required"/>
                    <input type="hidden" id="token" value="${get_csrf_token()}"/>
                    </div>
                    <a href="#" id="listing-submit-clicked" class="btn btn-pink">Submit</a>
                    </form>
                    %endif
                    </div>


                    <div class="col-md-6 text-right">
                    <a href="${request.route_url('edit_listing', name=listing.name)}" id = "update-listing" class="btn btn-pink">Update Listing</a>
            </div>
                </div>
                     %endif
                    </div>

    </div>
  </div>
</div>

       %endif
        %if request.has_permission('admin'):
                <a href="#confirm-modal"  id="edit"
            data-toggle="modal" data-target="#confirm-modal"
                                     class="btn btn-default" > &times; Delete</a>
                ${delete_modal("Are you sure you want to delete this listing?",request.route_url('delete_listing', id=listing.id))}
        %endif
        %if request.has_permission('admin'):
                        <a  data-value="${listing.id}"
                        class="btn btn-default approve-property"
                        data-toggle="tooltip" title="Approve">
                        ${'Approved' if listing.approved else "Approve"}
                     </a>

                      %endif
            %if request.has_permission('admin'):
                        <a  data-value="${listing.id}"
                        class="btn btn-default decline-property"
                        data-toggle="tooltip" title="Decline">
                       ${'Declined' if listing.declined else "Decline"}
                     </a>
                      %endif
           %if request.has_permission('edit'):

                  <button data-value="${listing.id}" data-user_id="${listing.user_id}" data-positive = "${1 if listing.featured else 0}"
                                         class="btn btn-default make-premium">
                                 %if not listing.featured:
                                         Make Premium
                                      %else:
                                      Remove Premium
                                 %endif
               </button>
             %endif
</div>
</%def>
<%def name="saveanddetails(listing)">
    <div class="btn-group">
    %if request.user:
        %if listing in request.user.favourites:
         <a class="make-favourites" style="color:#ff3ac7" data-value=${listing.id}
              data-positive="1" data-toggle="tooltip" title="Saved">
<span class="fa fa-heart fa-2x"></span></a>
            %else:
            <a class="make-favourites" style="color:#000" data-value=${listing.id}
              data-positive="0" data-toggle="tooltip" title="Save">
<span class="fa fa-heart fa-2x"></span></a>
            %endif
    %endif
    ## <a href="${request.route_url('property_view',name=listing.name)}" class="btn btn-danger">Details</a>
    </div>
</%def>