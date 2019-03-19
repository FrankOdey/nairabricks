<div id="eandp">
<p>Review the account information listed below. You can change the email address and password that you use to log in to Nairabricks. <strong>Note:</strong> changing your email will also change the account where you receive email alerts.</p>
${form.begin(method="post",url=request.route_url("email_pass"),id='ChangeEmailAndPassword', class_="form-horizontal", role="form")}
   <input type="hidden" name="csrf_token" id="csrf_token" value="${get_csrf_token()}">
    <p>Current Email: ${user.email}</p>
  <div class="form-group">
    ${form.label("Email", class_="col-sm-3 control-label")}
    <div class="col-sm-6">
      ${form.text('email',class_="form-control required", placeholder=user.email)}
    </div>
  </div>
  <div class="form-group">
    ${form.label('Current Password',class_="col-sm-3 control-label")}
    <div class="col-sm-6">
      ${form.password("old_password", class_="form-control required", placeholder="Current Password")}
    </div>
  </div>
    <div class="form-group">
    ${form.label('Password',class_="col-sm-3 control-label")}
    <div class="col-sm-6">
      ${form.password("password", class_="form-control required", placeholder="Password")}
    </div>
  </div>
  <div class="form-group">
   ${form.label('confirm password', class_="col-sm-3 control-label")}
    <div class="col-sm-6">
    ${form.password('confirm_password',class_="form-control required", placeholder="Confirm Password")}
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-10">
      <button type="cancel" name='cancel' class="btn btn-default">Cancel</button>
      <button type="submit" name="pass_submitted" class="btn btn-pink">Submit</button>
    </div>
  </div>
${form.end()}
</div>
