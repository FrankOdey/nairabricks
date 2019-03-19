<%inherit file="buddy:templates/dash/base.mako" />

<div class="row">
    <div class="col-md-12">
	<h4>Users</h4>
<form method="GET" action="${request.route_url('search_user_list')}">
				<input name="search" type="text" value="" placeholder="Enter names to search" class="form-control">
			</form>
			</div>

</div>

<br>
%if paginator:
<div class="uk-grid">
<div class="uk-width-medium-1-1">
<div class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</div>
</div>
</div>
<div class="table-responsive">
<table class="table table-striped table-condensed">
	<thead>
	<th>Fullname</th>
	<th>Email</th>
	<th>Groups</th>
	<th>Joined Date</th>
    <th>Verify</th>
	<th>Make Admins</th>
	<th>Deny Admins</th>
	</thead>
<tbody>
	%for item in paginator.items:
	<tr>
		<td><a href="${request.route_url('profile', prefix=item.prefix)}">${item.fullname}</a>
        %if item.is_verified:
            <label class="uk-badge uk-badge-success"><span class="glyphicon glyphicon-ok"></span></label>
        %endif
        ${item.total_visits}
        </td>
		<td>${item.email}</td>
		<td>${[g.name for g in item.mygroups]}</td>
		<td>${item.join_date.date()}</td>
        <td><a href="${request.route_url('verify_user',prefix=item.prefix)}" class="btn btn-warning btn-xs"> Verify</a>
        <a href="${request.route_url('deny_verified',prefix=item.prefix)}" class="btn btn-warning btn-xs">Deny Verified</a>
        </td>
		<td>
		<a href="${request.route_url('make_admin', id=item.id,pos='superadmin')}" class="btn btn-danger btn-xs">Superadmin</a>
		<a href="${request.route_url('make_admin', id=item.id,pos='admin')}" class="btn btn-warning btn-xs">Admin</a>
		<a href="${request.route_url('make_admin', id=item.id,pos='supermod')}" class="btn btn-info btn-xs">Supermod</a>
		<a href="${request.route_url('make_admin', id=item.id,pos='mod')}" class="btn btn-pink btn-xs">Mod</a>
		</td>
		<td>
		<a href="${request.route_url('deny_admin', id=item.id,pos='superadmin')}" class="btn btn-danger btn-xs">Superadmin</a>
		<a href="${request.route_url('deny_admin', id=item.id,pos='admin')}" class="btn btn-warning btn-xs">Admin</a>
		<a href="${request.route_url('deny_admin', id=item.id,pos='supermod')}" class="btn btn-info btn-xs">Supermod</a>
		<a href="${request.route_url('deny_admin', id=item.id,pos='mod')}" class="btn btn-pink btn-xs">Mod</a>
            	</td>
	</tr>
	%endfor
</tbody>
</table>
</div>
<div class="row">
<div class="col-md-12">
<p class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
</div>
</div>
%endif
