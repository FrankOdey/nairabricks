<%inherit file = "buddy:templates/dash/base.mako"/>

<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<section class="content-header">
      <h1>
        Dashboard
          <small>Add District</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="${request.route_url('view_lga', lga_id=lga.id)}"><i class="fa fa-dashboard"></i> ${lga.name}</a></li>
          <li class="active"><a href="#"><i class="fa fa-dashboard"></i>Add districts</a></li>
      </ol>
    </section>
<section class="content">
    <div class="box box-default">
        <div class="box-header">
            <h3 class="box-title">Add districts to ${lga.name}</h3>
        </div>
        <div class="box-body">
${form.begin(url=action_url, method="post")}

<input type="hidden" name="csrf_token" value="${get_csrf_token()}">

<div class="form-group">
	${form.label("Name")}
		${form.text("name", class_="form-control")}
		<p class="help-block">Please enter a comma separated list of lga to add e.g Onitsha etc.</p>
		${validate_errors("name")}
</div>
<input type="submit" name="form_submitted" value="Save" class="btn btn-success pull-left">
			<input type="reset" name="form_reset" value="Cancel" class="btn btn-default pull-right" 
				onclick="location.href='${request.route_url('view_lga', lga_id=lga.id)}'">
	    
	${form.end()}

        </div>
    </div>
</section>