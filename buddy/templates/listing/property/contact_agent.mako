<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<div id="feedback"></div>
${form.begin(class_="agentForm",url=request.route_url('mail_agents'), method="post", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
    <input type="hidden" id="camefrom" name="camefrom" value=${listing.name} />
  <div class="form-group">
    ${form.text("fullname", class_="form-control required", placeholder="Full Name *")}
    ${validate_errors('fullname')}
  </div>
<div class="form-group">
    ${form.text("mobile", class_="form-control", id="phone", placeholder="Mobile")}
    ${validate_errors('mobile')}
  </div>

  <div class="form-group">
    ${form.text("email", class_="form-control required", id="email", placeholder="Your Email *")}
      ${validate_errors('email')}
  </div>
  <div class="form-group">
${form.textarea("body",content="I am Interested in your listing at Nairabricks. I will like to know more about "+listing.title+" in  "+listing.address+"."+" Please get in touch with me",
class_="form-control required",disabled="disabled", rows="6")}
      ${validate_errors('body')}
  </div>

<div class="form-group">
##<div class="g-recaptcha" data-sitekey="6Lf6ihgTAAAAANJaJRGcJe4JsSImOx9p4QCYSF93"></div>
${form.submit("submit",class_="btn btn-site btn-block loading", value="Email Agent")}
</div>

${form.end()}

