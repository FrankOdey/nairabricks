<%inherit file = "buddy:templates/dash/base.mako"/>
##<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>
<section class="content-header">
      <h1>
        Dashboard
          <small>My Listings</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="#">My Listings</a></li>
      </ol>
    </section>
<div class="content" id="mylisting">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#onreview" data-toggle="tab" aria-expanded="true"><span class="fa fa-hourglass"></span>Under Review</a></li>
              <li class=""><a href="#active_listing" data-toggle="tab" aria-expanded="false"><span class="fa fa-hand-o-up"></span>Active Listings</a></li>
              <li class=""><a href="#past" data-toggle="tab" aria-expanded="false">Past Sales</a></li>
              <li class=""><a href="#declined" data-toggle="tab" aria-expanded="false"><span class="fa fa-hand-o-down"></span> Declined Listing</a></li>
                <li class=""><a href="#favourite" data-toggle="tab" aria-expanded="false"><span class="fa fa-heart"></span> Favourite Listings</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="onreview">
                    %if onreview_paginator:
                        <div class="row">
                  %for item in onreview_paginator.items:
                      <div class="col-md-4">
                      ${zdetails(item)}
                     </div>
                  %endfor
                        </div>
                            <div class="row">
    <div class="col-md-push-6 col-md-6">
                        <p class="pagelist">
        ${onreview_paginator.pager(
'$link_previous $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
    </div>
                            </div>

                  %endif
              </div>
              <div class="tab-pane" id="active_listing">
                  %if active_paginator:
                      <div class="row">
                  %for item in active_paginator.items:
                      <div class="col-md-4">
                      ${zdetails(item)}
                      </div>
                  %endfor
                      </div>
                          <div class="row">
    <div class="col-md-push-6 col-md-6">
                      <p class="pagelist">
        ${active_paginator.pager(
'$link_previous $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
    </div>
                          </div>
                  %endif
              </div>
                <div class="tab-pane " id="past">
                    %if pastsales_paginator:
                        <div class="row">
                  %for item in pastsales_paginator.items:
                      <div class="col-md-4">
                      ${zdetails(item)}
                      </div>
                  %endfor
                        </div>
                            <div class="row">
    <div class="col-md-push-6 col-md-6">
                        <p class="pagelist">
                    ${pastsales_paginator.pager(
                        '$link_previous $link_next',
	                    link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	                    curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	                    symbol_next="Next",
	                    symbol_previous="Previous",
	                    show_if_single_page=True,
                        )}
                        </p>
    </div></div>
                  %endif
              </div>
                <div class="tab-pane " id="declined">
                    %if declined_paginator:
                        <div class="row">
                  %for item in declined_paginator.items:
                      <div class="col-md-4">
                      ${zdetails(item)}
                      </div>
                  %endfor
                        </div>
                        <div class="row">
    <div class="col-md-push-6 col-md-6">
                        <p class="pagelist">
        ${declined_paginator.pager(
'$link_previous $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
    </div>
                        </div>
                  %endif
              </div>
                <div class="tab-pane" id="favourite">
                    %if favourites_paginator:
                        <div class="row">
                  %for item in favourites_paginator.items:
                      <div class="col-md-4">
                      ${zdetails(item)}
                     </div>
                  %endfor
                        </div>
                            <div class="row">
    <div class="col-md-push-6 col-md-6">
                        <p class="pagelist">
        ${favourites_paginator.pager(
'$link_previous $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
    </div>
                            </div>
                  %endif
              </div>
            </div>
            </div>
        </div>
    </div>
</div>
