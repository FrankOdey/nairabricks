<%inherit file="buddy:templates/base/base.mako" />
<%namespace file="fields.mako" name="fields" import="*"/>

	<h1>Edit Tag</h1>
  	
		<a class="btn btn-pink" style="margin-right:10px;" href="${request.route_url('add_tag')}">
			Add New Tag
		</a>
	

	
	${form.begin(url=action_url, method="post")}
	    ${fields.body()}
	    
	    <div class="form-actions">
			<input type="submit" name="form_submitted" value="Save" class="btn btn-pink">
			<input type="reset" name="form_reset" value="Cancel" class="btn" 
				onclick="location.href='${request.route_url('tag_list')}'">
	    </div>
	${form.end()}
	
