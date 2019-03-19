<%inherit file="buddy:templates/base/layout.mako" />
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>


<%block name="script_tags">
${parent.script_tags()}
<script>
$("#reset").validate();
</script>
</%block>
<div class="container">
    <div class="row">
        <div class="col-sm-offset-2 col-md-offset-2 col-xs-12 col-md-8 col-sm-8">
            <div class="content">
    <div class="title">Choose new password</div>

${form.begin(url=action_url,id="reset", method="post", class_="form-horizontal", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
          <input type="hidden" class="form-control" name="user_id"/>
	</div>
 <div class="form-group">
	${form.label("password",class_="col-sm-2 col-md-2 col-lg-2 control-label")}<span class="req">*</span>
	<div class="col-sm-6 col-md-6 col-lg-6">
          ${form.password(name="password",  class_="form-control required")}
		${validate_errors("password")}
	</div>
</div>
<div class="form-group">
	${form.label("Confirm Password",class_="col-sm-2 col-md-2 col-lg-2 control-label")}<span class="req">*</span>
	<div class="col-sm-6 col-md-6 col-lg-6">
          ${form.password(name="confirm_password" , class_="form-control required")}
		${validate_errors("confirm_password")}
	</div>
</div>

 <div class="form-group">
	<div class="col-sm-offset-2 col-sm-6">
          <button type="submit" class="btn btn-success green" name="form_submitted">Send</button>
		</div>
</div>
        </form>
	</div>
            </div>
        </div>
    </div>
