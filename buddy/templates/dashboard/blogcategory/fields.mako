<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

	      ${form.label("Name", class_="control-label")}
		${form.text("name", class_="form-control")}
		${validate_errors("name")}
    </div>
    </div>

<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
${form.label("Parent")}
${form.select("parent",options=parent_categories,prompt="Choose the parent",class_="form-control")}
	${validate_errors("parent")}
</div>
</div>
	<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
${form.label("Description")}
${form.textarea("description",
	rows=15,class_="form-control")}
	${validate_errors("description")}
</div>
</div>


