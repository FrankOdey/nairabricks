<%inherit file = "buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%! 
from webhelpers.containers import distribute
from webhelpers.html.tools import js_obfuscate
 %>


<div class="row">
	<div class="col-xs-12">

<div class="wrapper">
<div class="title">
<h3><strong>File Uploads</strong></h3>
</div>
${form.begin(url=request.route_url('frontpage_upload'),id="filestep",multipart=True, method="post",class_="form-horizontal")}
${form.csrf_token(name="csrf_token")}
				${form.file("pics",class_="required", accept="image/jpg, image/png,image/jpeg")}
			${form.errorlist("pics")}
<br>
			${form.submit("submit","Upload",class_="btn btn-warning")}
${form.end()}
<br>
${up|n}
</div>
	</div>
</div>

