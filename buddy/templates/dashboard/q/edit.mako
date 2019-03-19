<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="fields.mako" name="fields" import="*"/>

	<h1>Edit Question Category</h1>
  	

	${form.begin(url=action_url, method="post")}
	    ${fields.body()}
	    
	    
			<input type="submit" name="form_submitted" value="Save" class="btn btn-pink">
			<input type="reset" name="form_reset" value="Cancel" class="btn" 
				onclick="location.href='${request.route_url('q_category_list')}'">
	${form.end()}
	
