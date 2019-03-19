<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<div class="modal fade" id="contactModal" tabindex="-1" role="dialog" aria-labelledby="contactModalLabel">
  <div class="modal-dialog modal-sm"  role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="contactModalLabel">Contact ${user.fullname}</h4>
      </div>
      <div class="modal-body">
${form.begin(url = request.route_url('contact_user',prefix = user.prefix),id="contactForm", method="post", role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">

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
${form.textarea("body",
class_="form-control required", rows="3", content="Hi, I saw your profile at nairabricks.com "
"and wish to contact you. please reply this email so we can talk", disabled="disabled")}
      ${validate_errors('body')}
  </div>
<div class="modal-footer">
         <div class="form-group">
         <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        ${form.submit('form_submitted',value="Submit", class_="btn btn-pink")}
        </div>
      </div>
        ${form.end()}
    </div>
  </div>
</div>
    </div>
