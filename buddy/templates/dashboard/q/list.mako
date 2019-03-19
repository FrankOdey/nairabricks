<%inherit file="buddy:templates/dash/base.mako"/>
<div class="title">
	<h4>Question Category <small> List of question category sorted  in aphabetical order</small></h4>

	</div>
	%if paginator.items:
		    %for item in paginator.items:
					    %if item.children:
			
				<table class="table table-striped">
					<thead>
						<tr>
							<th>${item.name}</th>
							<th>Action</th>
						</tr>
					<thead>
					<tbody>

                          %for child in item.children:
						<tr>
							<td valign="top">
							<a href="${request.route_url("q_category_edit", id=child.id)}">${child.name}</a>
							</td>
							<td valign="top">
							<a class="btn btn-pink btn-xs" href="${request.route_url("q_category_edit", id=child.id)}">
								Edit
							</a>
							<a class="btn btn-danger btn-xs" href="${request.route_url("delete_q_category", id=child.id)}">Delete</a>
							</td>
							</tr>
							%endfor


						</tbody>
					</table>
					%endif for children
					%endfor for  item in paginator.items
		%endif
		
			${paginator.pager()}
		
			

				