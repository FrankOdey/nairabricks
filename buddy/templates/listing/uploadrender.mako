<%! 
from webhelpers.containers import distribute
 %>
	%if files:
<div class="row">
			<div class="col-md-12">
		<%
	p = distribute(files,4,"V")
		%>
<div class = "table-responsive">
<table class="table table-striped">
		%for row in p:
		<tr>
			%for item in row:
			%if item:

	<td><img src="${request.storage.url(item.thumbnail)}" class="img-responsive media-object pull-left" height=auto width="100">
<a href="${request.route_url('delete_upload', photo_id=item.id,name=item.listing.name)}" class="btn btn-xs bg-purple pull-right">delete&times;</a></td>
			%endif
			%endfor		
			</tr>
		%endfor
		</table>
	</div>
	</div>
</div>
%endif