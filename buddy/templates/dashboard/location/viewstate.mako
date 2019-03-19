<%inherit file = "buddy:templates/dash/base.mako"/>
<section class="content-header">
      <h1>
        Dashboard
          <small>${state.name}</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="${request.route_url('list_state')}"><i class="fa fa-dashboard"></i> States</a></li>
          <li class="active"><a href="#"><i class="fa fa-dashboard"></i>${state.name}</a></li>
      </ol>
    </section>
<section class="content">
    <div class="box box-default">
        <div class="box-header">
            <h3 class="box-title">${state.name}</h3>
        </div>
        <div class="box-body">
	%if paginator:
<p class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>

		<table class="table table-striped table-bordered table-condensed">
	<thead>
	<tr>
		<th>LGA Name</th>
		<th>Actions</th>
	</tr>
	<tbody>
		%for c in paginator.items:
	<tr><td>${c.name}</td>
		<td><a class="btn btn-success" href="${request.route_url('edit_lga',lga_id=c.id,state_id=state.id)}" style="border-radius:0">Edit</a>
<a class="btn btn-success" href="${request.route_url('view_lga',lga_id=c.id)}" style="border-radius:0">View Districts</a>
		<a class="btn btn-danger" href="${request.route_url('delete_lga',lga_id=c.id, state_id=state.id)}" style="border-radius:0">Delete</a>
		</td>
	</tr>
		%endfor

	<tbody>
</table>

%endif
<a class="btn btn-pink pull-left" href="${request.route_url('list_state')}" style="border-radius:0px;">Go back to state list</a>

<a class="btn btn-pink pull-right" href="${request.route_url('add_lga',state_id=state.id)}" style="border-radius:0px;">Add LGA</a>


</div>
    </div>
</section>
