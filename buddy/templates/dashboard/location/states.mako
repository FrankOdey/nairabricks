<%inherit file = "buddy:templates/dash/base.mako"/>
<section class="content-header">
      <h1>
        Dashboard
          <small>States</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="#"><i class="fa fa-dashboard"></i> States</a></li>
      </ol>
    </section>
<section class="content">

    <div class="box box-default">
        <div class="box-header">
            <h3 class="box-title">State list <small> total is ${total}</small></h3>
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
	<tr><th>SN</th>
		<th>State Name</th>
		<th>Actions</th>
	</tr>
	<tbody>

	%for i,state in enumerate(paginator.items):
	<tr>
        <td>${i+1}</td>
<td><a href="${request.route_url('view_state',state_id=state.id)}" >${state.name}</a></td>
<td><a class="btn btn-success" href="${request.route_url('edit_state',state_id=state.id)}" style="border-radius:0">Edit</a>
##<a class="btn btn-pink" href="${request.route_url('view_state', ##state_id=state.id)}" style="border-radius:0">View Cities</a>
##<a class="btn btn-danger" ##href="${request.route_url('delete_state',state_id=state.id)}" ##style="border-radius:0">Delete</a></td>
</tr>
	%endfor
	</tbody>
</table>
%endif

<a class="btn btn-pink pull-right" href="${request.route_url('add_state')}" style="border-radius:0">Add more States</a>

        </div>
    </div>

</section>