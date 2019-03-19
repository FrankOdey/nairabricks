<%! 
from webhelpers.containers import distribute
 %>
	%if files:
<div class="row">
			<div class="col-xs-12 col-sm-12 col-md-12 alert alert-success">
		<%
	p = distribute(files,6,"V")
		%>
<div class = "table-responsive">
<table class="table table-striped">
		%for row in p:
		<tr>
			%for item in row:
			%if item:
	<td><img src="${request.storage.url(item.filename)}" class="img-responsive media-object pull-left" height=auto width="100">
<a href="${request.route_url('delete_frontpage_upload', id=item.id)}" class="btn pull-right">delete&times;</a></td>
			%endif
			%endfor		
			</tr>
		%endfor
		</table>
	</div>
	</div>
</div>
%endif
