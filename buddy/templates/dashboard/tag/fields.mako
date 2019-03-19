<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<input type="hidden" name="csrf_token" value="${get_csrf_token()}">


	${form.label("Name")}
	
		${form.text("name", class_="large", maxlength="100")}
		${validate_errors("name")}
	


