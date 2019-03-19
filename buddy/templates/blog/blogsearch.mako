<div  id="search-form-wrapper">
<ul class="nav nav-tabs">
  <li class="active "><a href="#general" data-toggle="tab"><span class="uk-icon-book">VOICES</span></a></li>
</ul>
<div class="tab-content">

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

</div><!-- /. tab-content -->

</div><!-- /. wrapper -->

