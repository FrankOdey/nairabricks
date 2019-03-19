<%inherit file="buddy:templates/dash/base.mako"/>
<div class="title">
	<h4>City Pictures Category Edit </h4>

	</div>

${form.begin(url = request.route_url('edit_citypiccategory', id=cate.id),id="cateForm",class_="form-inline", method="post", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
${form.text("name",class_="required")}
${form.submit('form_submitted',value="submit")}
${form.end()}