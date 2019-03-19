
    <div class="pixContainer">
         %if len(item.pictures.all())>0:
  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="img-resp" src="${request.storage.url(item.pictures.all()[0].filename)}" alt="${item.title}">
  </a>
        %else:
        <a href="${request.route_url('property_view',name = item.name)}">
  <img class="img-resp" src="${request.static_url('buddy:static/nopics.jpg')}" alt="${item.title}">
  </a>
  %endif
        <div class="card-caption">
            <h4 class="caption-title">${item.category.name.upper()} ${item.listing_type.upper()}</h4>
            <p class="listing-type-caption-spec"><span class="listing-type-caption-price  price">${item.price}</span>
             <span class="caption-photo-info label label-info"><small>${item.property_extra.bedroom or 0} bds<span class="sep">·</span>
                 ${item.property_extra.bathroom or 0} ba <span class="sep">·</span> ${item.property_extra.area_size} sqm</small></span>
            </p>
            <a href="${request.route_url('property_view',name = item.name)}" class="caption-address"><span class="fa fa-map-marker"></span> ${item.address}</a>
        </div>
  <div class="top-left">
%if item.user.is_verified:
        <img src="/static/verified.png" width="20" data-toggle="tooltip" data-placement="bottom"
             title="" data-original-title="Listed by verified professional">
    %else:
    <span class="fa fa-info-circle" data-toggle="tooltip" data-placement="bottom"
             title="Agent not yet verified"></span>

    %endif
  </div>
  <div class="top-right">
      ${saveanddetails(item)}
  <button class="btn btn-pink btn-flat">Premium</button>
  </div>
    </div>

