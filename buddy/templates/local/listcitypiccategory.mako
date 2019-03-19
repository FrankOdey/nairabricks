<%inherit file="buddy:templates/dash/base.mako"/>
<div class="title">
	<h4>City Pictures Category </h4>

	</div>
${form.begin(url = request.route_url('add_citypiccategory'),id="cateForm",class_="form-inline", method="post", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
${form.text("name",class_="required")}
${form.submit('form_submitted',value="create")}
${form.end()}
%if categories:

                <table class="table table-striped">
					<thead>
						<tr>
							<th>Name</th>
							<th>Action</th>
						</tr>
					<thead>
					<tbody>
                %for item in categories:
                <tr>
							<td valign="top">
							${item.name}
							</td>
							<td valign="top">
							<a class="btn btn-pink btn-xs" href="${request.route_url("edit_citypiccategory", id=item.id)}">
								Edit
							</a>
							<a class="btn btn-danger btn-xs" href="${request.route_url("delete_citypiccategory", id=item.id)}">Delete</a>
							</td>
				</tr>
                %endfor
                </tbody>
                </table>


%endif