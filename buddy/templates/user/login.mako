<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%block name="script_tags">
<script>
$("#forgot").validate({
    rules:{
        email:{email:true}
    }
});
    $("#login").validate({
        rules:{
            email:{email:true}
        }
    });
</script>
</%block>

<div class="container">

<div class="row" id="login-page">
    <div class="col-md-4 col-md-offset-4 ">
<div class="box box-primary">
    <div class="box-header">
        <h4 class="box-title"> Sign in</h4>
    </div>
    <div class="box-body">
        <p style="color:red">${message}</p>
    ${form.begin(url=url,method="POST",id="login", class_="form-horizontal",role="form",)}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
${form.hidden("came_from",value=came_from, class_="form_control")}
	</div>
 <div class="form-group ${error_cls}">
     <div class="col-md-12">
${form.label("Email*", class_="control-label")}
          ${form.text("email", class_="form-control required")}
		${validate_errors('email')}
		</div>
</div>
 <div class="form-group ${error_cls}">
     <div class="col-md-12">
${form.label("Password*", class_="control-label")}
          ${form.password("password", class_="form-control required")}
		${validate_errors('password')}
</div>
     </div>
<!--
        <div class="form-group">
            <div class="col-md-12">
                <div class="g-recaptcha" data-sitekey="6LdFRkgUAAAAAO1WDPKSMVJy5h_qPchbKCBMaMsw"></div>
            </div>
        </div>
        -->

<div class="form-group">
    <div class="col-md-12">
          <button type="submit" class="btn btn-pink btn-flat pull-right" name="form_submitted">Sign In</button>
        </div>
</div>
${form.end()}

            ${forgot_form()}

    </div>
    <div class="box-footer">
        <p>New? <a  href="${request.route_url('reg')}">Register</a></p>
<p><a data-toggle="modal" href="#MyModal">Forgot password ?</a>
</p>
    </div>
</div>

</div>
    </div>
</div>

<%doc>
forgot password
<div class="container">

    <div class="row">
		<div class="col-md-12 col-sm-12">

           ## ${registeration_form()}


            <hr>
</div>
</div>
</div>


</%doc>
<%def name="forgot_form()">
<div class="modal fade" id="MyModal" tabindex="-1" role="dialog" aria-labelledby="MyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyModalLabel"><strong>Forgot Password</strong></h4>
      </div>
      <div class="modal-body">
<p>Please Enter the email you registered with so we can send you a password reset link</p>
${form.begin(url=request.route_url('forgot_password'), id="forgot",method="post", class_="form-horizontal", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
 <div class="form-group">
     <div class="col-sm-offset-2 col-sm-6">
	${form.label("Email", class_="control-label")}
          ${form.text(name="email", id="email2", class_="form-control required")}
		${validate_errors("email")}
        </div>
</div>
 <div class="form-group">
     <div class="col-sm-offset-6 col-sm-3">
          <button type="submit" class="btn btn-success green" name="form_submitted">Send</button>
         </div>
		</div>
        </form>

</div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>
</%def>
<%doc>
Registeration form
</%doc>
<%def name="registeration_form()">
<div class="modal fade" id="MyReg" tabindex="-1" role="dialog" aria-labelledby="MyRegLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyRegLabel"><strong>Create Your Free Account</strong></h4>
      </div>
      <div class="modal-body">
<div class="row">
        <div class="reg-width">
	<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
 ${self.flash_messages()}
    <div class="row">
        <div class="col-sm-offset-3 col-sm-6">
        ${form.begin(url=request.route_url('reg'), method="POST",class_="form-horizontal", role="form")}
	<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
	<div class="form-group">
	<div class="col-lg-12">
	${form.label("Name")}
	${form.text("fullname",placeholder="Your public display name", class_="form-control")}
	${validate_errors("name")}
	</div>
	</div>
	<div class="form-group">
		<div class="col-lg-12">
	${form.label("email")}
	${form.text("email", class_="form-control", placeholder="Enter your email")}
	${validate_errors("email")}
	</div>
	</div>
	<div class="form-group">
		<div class="col-lg-12">
	${form.label("password")}
	${form.password("password" ,class_="form-control", placeholder="Enter password")}
	${validate_errors("password")}
	</div>
	</div>
	<div class="form-group">
		<div class="col-lg-12">
	${form.label("Confirm Your password")}
	${form.password("confirm_password" ,class_="form-control", placeholder="Re-type password")}
	${validate_errors("confirm_password")}
	</div>
	</div>
<div class="form-group">
	<div class="col-lg-12">
<button type="submit" name="form_submitted" class="btn btn-pink">Sign Up for Free</button>
</div>
</div>
	${form.end()}


        </div>
</div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>
    </div>
    </div>
  </div>
</div>
</%def>
