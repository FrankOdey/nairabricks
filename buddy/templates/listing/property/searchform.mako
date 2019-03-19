<div  id="search-form-wrapper" >
<ul class="nav nav-tabs">
<li><a href="#forsale" data-toggle="tab"><span class="uk-icon-home">PROPERTIES</span></a></li>
  <li class="active "><a href="#general" data-toggle="tab"><span class="uk-icon-book">VOICES</span></a></li>
  <li><a href="#professionals" data-toggle="tab"><span class="glyphicon glyphicon-user">PROFESSIONALS</span></a></li>
</ul>
<div class="tab-content">
<div class="tab-pane fade  hidden-xs" id="forsale">
	${form.begin(method="get",id="search-form", role="form")}
<div class='form-inline'>
    <div class="form-group">
    ${form.label('I want to', class_='sr-only')}
    ${form.select('type',options=['Buy','Rent'])}
        </div>
<div class="form-group">
	${form.label('state', class_="sr-only")}
	${form.text('state',placeholder='Enter State and city', class_="form-control")}
</div>
<div class="form-group">
	${form.label('listing number', class_="sr-only")}
	${form.text('listing_no', class_="form-control", id="listing_no_search", placeholder="Listing #")}
</div>
<div class="form-group">
	${form.label('property type',class_="sr-only")}
	${form.select('property_type', options=h.get_pcategories(),multiple="multiple")}
</div>

<%doc>
</div>

<div class='form-inline' id="searchform-down">
<div class="form-group">
	${form.label('minimum price',class_="sr-only")}
	${form.text('min_price',class_="form-control", placeholder="Min Price")}
</div>
</%doc>

<div class="form-group">
	${form.label('maximum price',class_="sr-only")}
	${form.text('max_price',class_="form-control", placeholder="Max Price")}
</div>
<%doc>
<div class="form-group">
	${form.label('Beds',class_="sr-only")}
	${form.select('beds',options=[(1,'1+beds'),(2,'2+beds'),(3,'3+beds'),(4,'4+beds'),(5,'5+beds')],class_="form-control", prompt="Any Beds")}
</div>
<div class="form-group">
	${form.label('Baths',class_="sr-only")}
	${form.select('baths',options=[(1,'1+baths'),(2,'2+baths'),(3,'3+baths'),(4,'4+baths'),(5,'5+baths')],class_="form-control", prompt="Any baths")}
</div>
<div class="form-group">
	${form.label('area size',class_="sr-only")}
	${form.select('area_size',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m'),(1600,'1600+ Sq m'),(1800,'1800+ Sq m'),(2000,'2000+ Sq m'),
(2250,'2250+ Sq m'),(2750,'2750+ Sq m')],class_="form-control", prompt="Any area size")}
</div>
<div class="form-group">
	${form.label('covered area size',class_="sr-only")}
	${form.select('covered_area',options=[(600,'600+ Sq m'),(800,'800+ Sq m'),(1000,'1000+ Sq m'),
(1200,'1200+ Sq m'),(1400,'1400+ Sq m')],class_="form-control", prompt="Any covered area size")}
</div>
<div class="form-group">
	${form.label('transaction type',class_="sr-only")}
	${form.select('transaction_type',options=['New Property','Resale','Foreclosure'],class_="form-control", prompt="Any transaction type")}
</div>
</%doc>

	<div class="form-group">
	<button type="button" name="search-submitted" class=" pro-btn" data-message="Please use 'find homes navigation link'
	 no much thing to search. Apologies" data-status="primary"><span class="glyphicon glyphicon-search btn btn-pink">Search</span> </button>
	</div>
</div>

${form.end()}
</div>
<div class="tab-pane fade in active" id="general">

<form action="${request.route_url('search')}" method="get" id="search-form">
<div class="input-group col-lg-8">
  <input type="text" name='search_term' placeholder="Enter keywords or title to search" class="form-control">
  <span class="input-group-btn">
<button  type="submit"><span class="glyphicon glyphicon-search btn btn-pink">Search</span> </button>
</span>
</div>
       </form>
</div>
<div class="tab-pane fade" id="professionals">
    ${form.begin(url=request.route_url('search-users'),method="get", id="search-form")}
<div class="input-group col-lg-8">
  <input type="text" name='search_term' placeholder="Enter name to search, an empty search finds all" class="form-control">
  <span class="input-group-btn">
<button  type="submit"><span class="glyphicon glyphicon-search btn btn-pink">Search</span> </button>
</span>
</div>
    ${form.end()}
</div>
</div><!-- /. tab-content -->

</div><!-- /. wrapper -->

