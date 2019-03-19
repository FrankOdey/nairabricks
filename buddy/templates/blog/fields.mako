<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">

<div class="form-group">
${form.label("Category") }
${form.select("type_id", id="type_id",
	options=categories, prompt="Choose category", class_="form-control")}
	${validate_errors("type_id")}
</div>
%if tags:
   %for tag in tags:
${form.checkbox("tags", label=tag.name)}
	%endfor
%endif

<div class="form-group">
		${form.label("Title:", class_="control-label")}
		${form.text('title', class_="form-control",id="title")}
		${validate_errors("title")}
	
</div>
	<div class="form-group">
		${form.label("Body")}
		${form.textarea('body', rows="10", id="editor",class_="form-control")}
		${validate_errors('body')}
		
	</div>
	<div class="form-group">

<button type="submit" name="form_submitted" class="btn btn-pink">Submit</button>
</div>