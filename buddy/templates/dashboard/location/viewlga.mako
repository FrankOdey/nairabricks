<%inherit file = "buddy:templates/dash/base.mako"/>

<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<section class="content-header">
      <h1>
        Dashboard
          <small>LGAs</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="${request.route_url('view_state', state_id=state.id)}"><i class="fa fa-dashboard"></i> ${state.name}</a></li>
          <li class="active"><a href="#"><i class="fa fa-dashboard"></i>LGAs</a></li>
      </ol>
    </section>
<section class="content">
    <div class="box box-default">
        <div class="box-header">
            <h3 class="box-title">LGAs in ${state.name}</h3>
        </div>
        <div class="box-body">
	%if lga.district:
		<table class="table table-striped table-bordered table-condensed">
	<thead>
	<tr>
		<th>LGA Name</th>
		<th>Actions</th>
	</tr>
	<tbody>

		%for c in lga.district:
	<tr><td>${c.name}</td>
		<td><a class="btn btn-success" href="${request.route_url('edit_district',district_id=c.id,lga_id=lga.id)}" style="border-radius:0">Edit</a>
		##<a class="btn btn-danger" href="${request.route_url('delete_district',district_id=c.id, lga_id=lga.id)}" style="border-radius:0">Delete</a>
		</td>
	</tr>
		%endfor
	<tbody>
</table>
%endif
<a class="btn btn-pink pull-left" href="${request.route_url('view_state',state_id = lga.state.id)}" style="border-radius:0px;">Go back to ${lga.state.name}</a>

<a class="btn btn-pink pull-right" href="${request.route_url('add_district',lga_id=lga.id)}" style="border-radius:0px;">Add District(s)</a>

        </div>
    </div>
</section>