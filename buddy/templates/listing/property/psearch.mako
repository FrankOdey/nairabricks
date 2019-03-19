<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading text-center" role="tab" id="filterOptions">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOption" aria-expanded="false" aria-controls="collapseOne">
          Toggle Advanced Filter options
        </a>
      </h4>
    </div>
    <div id="collapseOption" class="panel-collapse collapse" role="tabpanel" aria-labelledby="filterOptions">
      <div class="panel-body">
<div class="row" id="psearchform">
    <div class="col-sm-12">
        ${form.begin(method="get",class_='form-horizontal',url=request.route_url('search_properties'),id="search-form", role="form")}
        <div class="row">
                <div class="col-xs-6">
	<label for="transactiontype" class="control-label">Transaction type</label>
	${form.select('transaction_type',options=['New Property','Resale','Foreclosure'],
                selected_value=transaction_type, prompt="Any transaction type",class_="form-control")}
                </div>
            <div class="col-xs-6">
                <label for="ListingNumber" class="control-label">Listing Number</label>
	    ${form.text('listing_no', id="listing_no_search", placeholder="Listing #",class_="form-control")}
                </div>
                </div>

                <div class="row">
                <div class="col-xs-6">
    ${form.label('Category',class_='control-label')}
    ${form.select('type',options=['All categories','For sale','For rent', "Short let"],class_="form-control", selected_value=type,)}
                    </div>
                    <div class="col-xs-6">
                    ${form.label('Type', class_='control-label')}
	${form.select('property_type', options=h.get_pcategories(),selected_value=ptype,class_="form-control",prompt="Type")}

                        </div>
                </div>
            <div class="row">
                <div class="col-xs-6">
	${form.label('state', class_='control-label')}
	${form.select('state_id', options=sorted(h.get_states(),key=lambda x:x[1]),selected_value=state_id,prompt="Any State",class_="form-control required state_id")}
                    </div>
                <div class="col-xs-6">
	${form.label('Region',class_='control-label')}
	${form.select('lga_id', options=sorted(lgas, key=lambda x:x[1]),selected_value=lga_id,prompt="Any Region",class_="form-control required lga_id")}
                </div>
                </div>
        <div class="row">
                <div class="col-xs-6">
	<label for="MinimumPrice" class="control-label">Minimum Price</label>
	${form.text('min_price', placeholder="Min Price",value=min_price,class_="form-control price",size="10")}
                    </div>
                <div class="col-xs-6">
	<label for="MaximumPrice" class="control-label">Maximum Price</label>
	${form.text('max_price', placeholder="Max Price",value=max_price,class_="form-control price",size="10")}
                </div>
                </div>
        <div class="row">
                <div class="col-xs-6">
	${form.label('Beds',class_="control-label")}
	${form.select('beds',options=[(1,'1+beds'),(2,'2+beds'),(3,'3+beds'),(4,'4+beds'),(5,'5+beds')],selected_value=beds, prompt="Any Beds",class_="form-control")}
                    </div>
                <div class="col-xs-6">
	${form.label('Baths',class_="control-label")}
	${form.select('baths',options=[(1,'1+baths'),(2,'2+baths'),(3,'3+baths'),(4,'4+baths'),(5,'5+baths')],selected_value=baths, prompt="Any baths",class_="form-control")}
                </div>
                </div>
        <div class="row">
                <div class="col-xs-6">
	<label for="AreaSize" class="control-label">Area Size</label>
	${form.select('area_size',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m'),(1600,'1600+ Sq m'),(1800,'1800+ Sq m'),(2000,'2000+ Sq m'),
(2250,'2250+ Sq m'),(2750,'2750+ Sq m')],selected_value=area_size, prompt="Any area size",class_="form-control")}
                    </div>
                <div class="col-xs-6">
	<label for="CoveredAreaSize" class="control-label">Covered Area Size</label>
	${form.select('covered_area',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m')],selected_value=covered_area, prompt="Any covered area size",class_="form-control")}
                </div>
                </div>
        <div class="row">
        <div class="col-xs-12" style="margin-top: 10px">
<button type="submit" name="search-submitted" class="btn btn-pink btn-block">Search </button>
            </div> </div>
       ${form.end()}
        </div>
</div>
        </div>
</div>
  </div>
</div>