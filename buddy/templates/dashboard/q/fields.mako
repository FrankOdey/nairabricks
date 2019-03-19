<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<input type="hidden" name="csrf_token" value="${get_csrf_token()}">


	      ${form.label("Name", class_="control-label")}
	
		${form.text("name", class_="form-control")}
		${validate_errors("name")}
	


