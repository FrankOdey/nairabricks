<%inherit file = "buddy:templates/user/userbase.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>

<section>
<div class="row" id="listing-list">
	<div class="col-sm-12" >
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
              <li class="active"><a href="#active_listing" data-toggle="tab" aria-expanded="false"><span class="fa fa-hand-o-up"></span>Active Listings</a></li>
              <li class=""><a href="#past" data-toggle="tab" aria-expanded="false">Past Sales</a></li>

            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="active_listing">
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
	        </div>
        </div>

    </div>
    </div>
    </section>
