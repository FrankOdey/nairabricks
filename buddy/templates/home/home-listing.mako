<div id="featuredproducts-carousel" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->

  <!-- Wrapper for slides -->
  <div class="carousel-inner">
    <div class="item active">

%for listing in listings[0:4]:
		<a href="${request.route_url('property_view',name=listing.name)}">
		<img src="${request.storage.url(listing.pictures[0].thumbnail)}" alt="${listing.title}" style="display:inline-block"/>
	<div>
	<h4>${listing.title}</h4>
		<p class="price">
				${listing.price}
		</p>
		<p class="listingdetails">
		<span class="glyphicon glyphicon-map-marker"></span>
			${listing.state.name}
		</p>
	</div>
			</a>

%endfor

    </div>
%if len(listings)>4:

    <div class="item">
%for listing in listings[4:8]:
<a href="${request.route_url('property_view',name=listing.name)}">
<img src="${request.storage.url(listing.pictures[0].thumbnail)}" alt="${listing.title}" style="display:inline-block">
<div>
	<h4>${listing.title.title()}</h4>
		<p class="price">
				${listing.price}
		</p>
		<p class="listingdetails">
		<span class="glyphicon glyphicon-map-marker"></span>
			${listing.state.name}
		</p>
	</div>

	</a>
%endfor
	</div>
	%endif
%if len(listings)>9:

    <div class="item">
%for listing in listings[9:13]:
<a href="${request.route_url('property_view',name=listing.name)}">
<img src="${request.storage.url(listing.pictures[0].thumbnail)}" alt="${listing.title}" style="display:inline-block">
<div>
	<h4>${listing.title.title()}</h4>
		<p class="price">
				${h.format_money(listing.price)}
		</p>
		<p class="listingdetails">
		<span class="glyphicon glyphicon-map-marker"></span>
			${listing.state.name}
		</p>
	</div>

	</a>
%endfor
	</div>
	%endif
  </div>

  <!-- Controls -->
 <a class="left carousel-control" href="#featuredproducts-carousel" data-slide="prev" role="button">
   <span class="glyphicon glyphicon-circle-arrow-left" aria-hidden="true"></span>
  </a>
  <a class="right carousel-control pull-right " role="button" href="#featuredproducts-carousel" data-slide="next">
   <span class="glyphicon glyphicon-circle-arrow-right" aria-hidden="true"></span>
  </a>

</div>