

<div class="category-nav">
<nav class="navbar navbar-inverse" role="navigation" style="margin-top:-20px;">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapse-2">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>

    </div>

<div class="collapse navbar-collapse" id="navbar-collapse-2">
 <ul class="nav navbar-nav">

  <li class="${'active' if review else ''}"><a href="${request.route_url('view_local',name=locality.name)}">Reviews</a></li>
  <li class="${'active' if photos else ''}"><a href="${request.route_url('city_pictures',name=locality.name)}">Photos</a></li>
  <li class="${'active' if pro else ''}"><a href="${request.route_url('city_properties',name=locality.name)}">Properties</a></li>

 </ul>
</div>
</nav>

</div>