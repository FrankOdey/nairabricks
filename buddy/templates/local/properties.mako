<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>
<%inherit file = "buddy:templates/base/base.mako"/>

<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <div class="blog-wrapper">
                   <h1 class="text-center">${locality.city_name} in ${locality.state.name}</h1>
                    <%include file="citynav.mako"/>
<h4>ACTIVE LISTINGS<small>(${len(active_paginator)})</small></h4>
%if active_paginator:

	%for item in active_paginator.items:

<div class="uk-grid" id="listing-list" style="font-size: 12px">
    <div class="uk-width-medium-4-10 ">
    %if len(item.pictures.all())>0:
  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="listing-img" src="${request.storage.url(item.pictures.all()[0].filename)}" alt="">
  </a>

        %else:
         <a href="${request.route_url('property_view',name = item.name)}">
                           <img  class="listing-img" src="${request.static_url('buddy:static/nopics.jpg')}"  alt="">
                    </a>
  %endif
  </div>
<div class="uk-width-medium-6-10">
${details(item)}
</div>
</div>
<hr>

	%endfor

<div class="wrapper pull-right" style="padding:0px;">${active_paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</div>
    %else:

    <h1 class="text-muted">No active Listing in this city now</h1>
%endif
<h4>PAST SALES<small>(${len(pastsales_paginator)})</small></h4>
%if pastsales_paginator:

	%for item in pastsales_paginator.items:

<div class="uk-grid" id="listing-list" style="font-size: 12px">
    <div class="uk-width-medium-4-10 ">
    %if len(item.pictures.all())>0:
  <a href="${request.route_url('property_view',name = item.name)}">
  <img class="listing-img" src="${request.storage.url(item.pictures.all()[0].filename)}" alt="">
  </a>

        %else:
        <a href="${request.route_url('property_view',name = item.name)}">
                           <img  class="listing-img" src="${request.static_url('buddy:static/nopics.jpg')}"  alt="">
                    </a>
  %endif
  </div>
<div class="uk-width-medium-6-10">
${details(item)}
</div>
</div>
<hr>

	%endfor

<div class="wrapper pull-right" style="padding:1px;">${pastsales_paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</div>
    %else:

    <h1 class="text-muted">No past sales in this city</h1>
%endif

                </div>
        </div>
    </div>
</div>