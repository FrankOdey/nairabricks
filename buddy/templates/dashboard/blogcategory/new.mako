<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="fields.mako" name="fields" import="*"/>

<div class= 'row'>
    <div class="col-sm-offset-2 col-sm-8">
	
	<h2>Add Categories</h2>

	
	${form.begin(url=action_url, method="post")}
	    ${fields.body()}
	    
			<input type="submit" name="form_submitted" value="Save" class="btn btn-pink">
			<input type="reset" name="form_reset" value="Cancel" class="btn" 
				onclick="location.href='${request.route_url('blog_category_list')}'">
	    </div>
	${form.end()}
	</div>
	</div>
	
  
