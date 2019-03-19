<%inherit file="buddy:templates/base/base.mako" />
<%namespace file="fields.mako" name="fields" import="*"/>

	
	<h2>Add New Tag</h2>

	
	${form.begin(url=action_url, method="post")}
	    ${fields.body()}
	    
			<input type="submit" name="form_submitted" value="Save" class="btn btn-pink">
			<input type="reset" name="form_reset" value="Cancel" class="btn" 
				onclick="location.href='${request.route_url('tag_list')}'">
	    </div>
	${form.end()}
	
  
