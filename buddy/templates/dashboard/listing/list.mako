<%inherit file="buddy:templates/dash/base.mako"/>
<div class="title">
	<h4>Property Category <small> List of property category sorted  in aphabetical order</small></h4>

	</div>

	%if paginator:
	<div class="row">
<div class="col-sm-12">
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
							<a href="${request.route_url("listing_category_edit", id=child.id)}">${child.name}</a>
							</td>
							<td valign="top">
							<a class="btn btn-pink btn-xs" href="${request.route_url("listing_category_edit", id=child.id)}">
								Edit
							</a>
							<a class="btn btn-danger btn-xs" href="${request.route_url("delete_listing_category", id=child.id)}">Delete</a>
							</td>
							</tr>
							%endfor


						</tbody>
					</table>
					%endif for children
					%endfor for  item in paginator.items
		<div class="row">
<div class="col-sm-12">
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
		

		
			

				