<%inherit file="buddy:templates/base/base.mako" />
	<h2>Tag Lists <small> List of tags sorted  in aphabetical order</small></h2>
		
		<a class="btn btn-pink pull-right"
			href="${request.route_url('add_tag')}">Add New Tag</a>
	
	%if paginator.items:
		
			
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Name</th>
							<th style="width: 130px;"></th>
						</tr>
					<thead>
					<tbody>
					%for item in paginator.items:
						<tr>
							<td valign="top">
							<a href="${request.route_url("tag_edit", tag_id=item.id)}">${item.name}</a>
							</td>
							<td valign="top">
							<a class="btn" href="${request.route_url("tag_edit", tag_id=item.id)}" style="height: 14px;">
								Edit</a>
							<a class="btn" style=height:14px;" href="${request.route_url("delete_tag", tag_id=item.id)}">Delete</a>
							</td>
							</tr>
							%endfor
						</tbody>
					</table>
		%endif
		
			${paginator.pager()}
		
			

				