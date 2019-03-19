<div  id="search-form-wrapper">
<ul class="nav nav-tabs nav-justified">
<li class="active "><a href="#forsale" data-toggle="tab"><span class="glyphicon glyphicon-home"> PROPERTIES</span></a></li>
##  <li class="hidden"><a href="#general" data-toggle="tab"><span class="uk-icon-book">VOICES</span></a></li>
  ##<li><a href="#professionals" data-toggle="tab"><span class="glyphicon glyphicon-user"> PROFESSIONALS</span></a></li>
</ul>
<div class="tab-content">
<div class="tab-pane fade in active" id="forsale">
	${form.begin(method="get",url=request.route_url('search_properties'),id="search-form", role="form")}
     <div class="row">
        <div class="col-sm-6">
        <div class="row">
                <div class="col-xs-6">
	${form.label('state', class_='control-label')}
	${form.select('state_id', options=sorted(h.get_states(),key=lambda x:x[1]),prompt="Any State",class_="form-control required state_id")}
                    </div>
                <div class="col-xs-6">
	${form.label('Region',class_='control-label')}
	${form.select('lga_id', options=[],prompt="Any Region",class_="form-control required lga_id")}
                </div>
                </div>
        </div>
        <div class="col-sm-6">
            <div class="row">
                <div class="col-xs-6">
    ${form.label('Category',class_='control-label')}
    ${form.select('type',options=['All categories','For sale','For rent', 'Short let'],class_="form-control",)}
                    </div>
                    <div class="col-xs-6">
                    ${form.label('Type', class_='control-label')}
	${form.select('property_type', options=h.get_pcategories(),class_="form-control",prompt="Type")}

                        </div>
                </div>

        </div>
    </div>

    <div id="advanced-search" style="display: none">
<div class="row">
<div class="col-sm-6">
    <div class="row">
                <div class="col-xs-6">
	${form.label('Beds',class_="control-label")}
	${form.select('beds',options=[(1,'1+beds'),(2,'2+beds'),(3,'3+beds'),(4,'4+beds'),(5,'5+beds')], prompt="Any Beds",class_="form-control")}
                    </div>
                <div class="col-xs-6">
	${form.label('Baths',class_="control-label")}
	${form.select('baths',options=[(1,'1+baths'),(2,'2+baths'),(3,'3+baths'),(4,'4+baths'),(5,'5+baths')], prompt="Any baths",class_="form-control")}
                </div>
                </div>
</div>
    <div class="col-sm-6">
        <div class="row">
                <div class="col-xs-6">
	${form.label('minimum price',class_="control-label")}
	${form.text('min_price', placeholder="Min Price",class_="form-control price",size="10")}
                    </div>
                <div class="col-xs-6">
	${form.label('maximum price',class_="control-label")}
	${form.text('max_price', placeholder="Max Price",class_="form-control price",size="10")}
                </div>
                </div>

    </div>
</div>
        <div class="row">
        <div class="col-sm-6">
            <div class="row">
                <div class="col-xs-6">
	${form.label('transaction type',class_="control-label")}
	${form.select('transaction_type',options=['New Property','Resale','Foreclosure'],
                 prompt="Any transaction type",class_="form-control")}
                </div>
            <div class="col-xs-6">
                ${form.label('listing number',class_='control-label')}
	    ${form.text('listing_no', id="listing_no_search", placeholder="Listing #",class_="form-control")}
                </div>
                </div>
        </div>
         <div class="col-sm-6">
              <div class="row">
                <div class="col-xs-6">
	${form.label('area size',class_="control-label")}
	${form.select('area_size',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m'),(1600,'1600+ Sq m'),(1800,'1800+ Sq m'),(2000,'2000+ Sq m'),
(2250,'2250+ Sq m'),(2750,'2750+ Sq m')], prompt="Any area size",class_="form-control")}
                    </div>
                <div class="col-xs-6">
	${form.label('covered area size',class_="control-label")}
	${form.select('covered_area',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m')], prompt="Any covered area size",class_="form-control")}
                </div>
                </div>
        </div>
    </div>
        </div>
        <div class="row">
        <div class="col-xs-12" style="margin-top: 10px">
            <a id="show-advanced" class="text-center " role="button" style="color:#fff;text-decoration: none;" href="#">
  Toggle Advanced Search Options
</a>
<button type="submit" name="search-submitted" class="btn btn-danger pull-right"><span class="glyphicon glyphicon-search"></span>  Search </button>
            </div> </div>
${form.end()}
</div>
<div class="tab-pane fade hidden" id="general">

<form action="${request.route_url('search')}" method="get" id="search-form-2">
<div class="input-group col-lg-8">
  <input type="text" name='search_term' placeholder="Enter keywords or title to search" class="form-control">
  <span class="input-group-btn">
<button class="btn btn-pink" type="submit"><span class="glyphicon glyphicon-search"></span> Search</button>
</span>
</div>
       </form>
</div>
<div class="tab-pane fade" id="professionals">
    ${form.begin(url=request.route_url('search-users'),method="get", id="search-form-3")}
<div class="input-group col-lg-8">
  <input type="text" name='search_term' placeholder="Enter name to search, an empty search finds all" class="form-control">
  <span class="input-group-btn">
<button class="btn btn-danger" type="submit"><span class="glyphicon glyphicon-search"></span> Search</button>
</span>
</div>
    ${form.end()}
</div>
</div><!-- /. tab-content -->
</div><!-- /. wrapper -->

