<%inherit file="buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<div class="page-id">
    <div class="container">
        <div class="col-md-12">
            <h1 class="page-title">Contact us</h1>
        </div>

    </div>
</div>
<div class="container">
    <div class="col-md-6">
        <div class="hz_yt_bg">
       <p> We are happy to hear from you! Please send us a message</p>
    ${form.begin(class_="contactForm", method="post", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">

  <div class="form-group">
    ${form.text("fullname", class_="form-control required", placeholder="Full Name *")}
    ${validate_errors('fullname')}
  </div>
  <div class="form-group">
    ${form.text("email", class_="form-control required", id="email", placeholder="Your Email *")}
      ${validate_errors('email')}
  </div>
  <div class="form-group">
${form.textarea("body",class_="form-control required", rows="6")}
      ${validate_errors('body')}
  </div>

<div class="form-group">

${form.submit("submit",class_="btn btn-site btn-block loading", value="Send Message")}
</div>

${form.end()}
</div>
        </div>
<div class="col-md-4">
    <div class="hz_yt_bg">
Feel free to email us at info@nairabricks.com
        </div>
</div>
    </div>