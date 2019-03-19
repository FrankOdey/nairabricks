<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="pviewinclude.mako" import="saveanddetails"/>
<%block name="script_tags">
<script src="${request.static_url("buddy:static/sticky.js")}"></script>
  <script>
      $(function(){
  $("#sticker").sticky({topSpacing:0});
    });

    </script>

</%block>

<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<%def name="details(item)">

<div class="box bg-default">
    <div class="box-header">
        <div class="box-title">
 <a href="${request.route_url('property_view',name=item.name)}" >${item.title}</a>
            </div>
    </div>
    <div class="box-body">
<div class="row">
   <div class="col-xs-4">
       <div class="text-center">
    %if len(item.pictures.all())>0:
  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="listing-img" src="${request.storage.url(item.pictures.all()[0].filename)}" alt="${item.title}">
  </a>

           <p><span class="glyphicon glyphicon-camera"></span> ${len(item.pictures.all())}
            %if len(item.pictures.all())>1:
                Photos
             %else:
                Photo
             %endif
            </p>

        %else:
        <a href="${request.route_url('property_view',name = item.name)}">
  <img class="listing-img" src="${request.static_url('buddy:static/nopics.jpg')}" alt="${item.title}">
  </a>
  %endif

</div>
       %if item.user.is_verified:
        <img src="/static/verified.png" width="20" data-toggle="tooltip" data-placement="bottom"
             title="Listed By Verified Professional" alt="verified agent logo"/>
    %endif
        </div>
      <div class="col-xs-8">
<h4>
    <small>Listing #:${item.serial}</small>
    <span class="pull-right price" style="color: #9f0e8e">
                    ${item.price}
%if item.listing_type.lower()=="for rent":
    <small class="text-muted">yearly rent</small>
    %elif item.listing_type.lower() == "short let":
    <small class="text-muted">short let</small>
%endif
                  </span>
    </h4>
          <h6><span class="glyphicon glyphicon-map-marker"></span>
 %if item.show_address:
     <b>${item.address}</b>
%else:
Call agent for address
%endif

          </h6>
          ##<p class="">
          ##${h.remove_formatting(h.truncate(item.body,length=200))}
          ##</p>
          <hr class="hidden-xs">
<div class="row ">
<div class="col-sm-12">
<ul class="list-inline">
              <li data-toggle="tooltip" title="Beds"><i class="fa fa-bed" style="color: #9f0e8e"></i> ${item.property_extra.bedroom or 0} <b>bedroom</b></li> |
              <li data-toggle="tooltip" title="Baths"><i class="fa fa-bathtub" style="color: #9f0e8e"></i> ${item.property_extra.bathroom or 0} <b>bathroom</b></li> |
    <li data-toggle="tooltip" title="Car Spaces"><b>Car Space</b> <i class="fa fa-car" style="color: #9f0e8e"></i> ${item.property_extra.car_spaces} </li> |
<li data-toggle="tooltip" title="Covered Area Size"><b>Covered Area Size</b> <i class="fa fa-square" style="color: #9f0e8e"></i> ${item.property_extra.covered_area} sqm</li> |
    <li data-toggle="tooltip" title="Land Size"><b>Land Size</b> <i class="fa fa-square" style="color: #9f0e8e"></i> ${item.property_extra.area_size} sqm</li>

    <li><b>Status:</b><span style="color: #9f0e8e">
                  %if item.status==False:
                  %if item.listing_type.lower()=="for sale":
                  Sold
                  %else:
                      Rented
                   %endif
                  %else:
                      Available
                  %endif
                  </span> </li>
    <p>
        <a href="${request.route_url('property_view',name=item.name)}" style="text-decoration: underline">More Details</a>
    </p>

          </ul>



    </div>

</div>


        </div>

</div>
        <div class="row">
        <div class="col-xs-8">
%if item.user.company_logo:
<a href="${request.route_url('profile',prefix=item.user.prefix)}">
    <img src="${request.storage.url(item.user.company_logo)}" alt="company logo" class="img-responsive" class="listing-branding"></a>
%else:
        <a href="${request.route_url('profile',prefix=item.user.prefix)}">${item.user.company_name or ''}</a>
%endif
        </div>
        <div class="col-xs-4">
            ${saveanddetails(item)}
        </div>
    </div>
</div>

</div>

</%def>

<%def name="zdetails(item)">
    <div class="pixContainer">
         %if len(item.pictures.all())>0:
  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="img-resp" src="${request.storage.url(item.pictures.all()[0].thumbnail)}" alt="${item.title}">
  </a>
        %else:
             %if item.category.name.lower() in ['agricultural land','residential land','commercial land','hotel sites','industrial land']:
                  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="img-resp" src="${request.static_url('buddy:static/nopicsthumbland.jpg')}" alt="${item.title}">
  </a>
                 %else:
                  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="img-resp" src="${request.static_url('buddy:static/nopicsthumb.jpg')}" alt="${item.title}">
  </a>
             %endif

  %endif
        <div class="card-caption">
            <h4 class="caption-title">${item.category.name.upper()} ${item.listing_type.upper()}</h4>
            <p class="listing-type-caption-spec"><span class="listing-type-caption-price  price">${item.price}</span>
             <span class="caption-photo-info label label-info"><small>${item.property_extra.bedroom or 0} bds<span class="sep">·</span>
                 ${item.property_extra.bathroom or 0} ba <span class="sep">·</span> ${item.property_extra.area_size} sqm</small></span>
            </p>
            <a href="${request.route_url('property_view',name = item.name)}" class="caption-address"><span class="fa fa-map-marker"></span> ${h.truncate(item.address,40)}</a>
        </div>
  <div class="top-left hidden">
%if item.user.is_verified:
        <img src="/static/verified.png" width="20" data-toggle="tooltip" data-placement="bottom"
             title="" data-original-title="Listed by verified professional">
    %else:
    <span class="fa fa-info-circle" data-toggle="tooltip" data-placement="bottom"
             title="Agent not yet verified"></span>

    %endif
  </div>
  <div class="top-right">${saveanddetails(item)}</div>
        %if item.featured:
            <div class="bottom-right">
            <span class="fa fa-certificate fa-2x" style="color:#ff3ac7" data-toggle="tooltip" data-placement="bottom"
             title="Premium Property"></span>
        </div>
        %endif

    </div>

</%def>