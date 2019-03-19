<%inherit file="buddy:templates/dash/base.mako"/>
<div class="row">
    <div class="col-md-6">
        <fieldset><legend>Create a local</legend>
${form.begin(url=request.route_url('add_local'),method="post", class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
<div class="col-xs-12 col-sm-12">
${form.select('state_id',options=[(s.id, s.name) for s in states],prompt="Select a state",
class_="form-control")}
</div>
</div>
<div class="form-group">
<div class="col-xs-12 col-sm-12">
${form.text('city_name',placeholder="City name", class_="form-control")}
</div>
</div>
<div class="form-group">
<div class="col-xs-12 col-sm-12">
<button name="form-submitted" type="submit" class="btn btn-pink">Create</button>
</div>
</div>
${form.end()}
</fieldset>
    </div>
    <div class="col-md-6">
        <div style="background: #ccc">
        <ul class="uk-nav uk-nav-side uk-nav-parent-icon" data-uk-nav>
   %for state in states:
       <li class="uk-parent">
           <a href="#">${state.name.capitalize()}</a>
           <ul class="uk-nav-side uk-nav-sub" style="background: #fff;">
	%if state.local:
	%for local in state.local:
		<li><a href="">${local.city_name}</a></li>
	%endfor
	%endif
       </ul>
       </li>
%endfor
             </ul>
</div>
    </div>
</div>