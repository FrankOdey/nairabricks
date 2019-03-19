<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<div class="eandp">
    ${form.begin(method="post",url=request.route_url('personal-update'),id="personal-form", role="form")}
   <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
    <div class="row">
        <div class="col-md-4">
            <div class="form-group">
    ${form.label("Firstname", class_="control-label")}

      ${form.text('firstname',class_="form-control required", value=user.firstname)}
    </div>
    <div class="form-group">
    ${form.label("Surname", class_="control-label")}
      ${form.text('surname',class_="form-control required", value=user.surname)}
  </div>
    <div class="form-group">
   ${form.label('Company name', class_="control-label")}
    ${form.text('company_name',class_="form-control",placeholder='Company name',value=user.company_name)}
        ${validate_errors('company_name')}
  </div>
    <div class="form-group">
   ${form.label('Location', class_="control-label")}
    ${form.select('state_id',class_="form-control required",options=states, selected_value=user.state_id)}
        ${validate_errors('state_id')}

  </div>
        </div>
        <div class="col-md-4">
    <div class="form-group">
   ${form.label('City', class_="control-label")}
    ${form.text('city',class_="form-control",placeholder='City',value=user.city)}
        ${validate_errors('city_id')}
    </div>

             <div class="form-group">
    ${form.label('User type',class_="control-label")}
      ${form.select("user_type_id",options=usertypes, class_="form-control", selected_value = user.user_type_id)}
        ${validate_errors('user_type_id')}
    </div>
  <div class="form-group">
    ${form.label('headline',class_="control-label")}
      ${form.text("headline", class_="form-control", placeholder="", value=user.headline)}
        ${validate_errors('headline')}
    </div>
    <div class="form-group">
   ${form.label('Address', class_="control-label")}
    ${form.text('address',class_="form-control", placeholder="Address", value=user.address)}
        ${validate_errors('address')}
    </div>
            </div>
        <div class="col-md-4">
    <div class="form-group">
   ${form.label('mobile', class_="control-label")}
    ${form.text('mobile',class_="form-control required",maxlength=11,value=user.mobile, placeholder="mobile")}
        ${validate_errors('mobile')}
     </div>
    <div class="form-group">
   ${form.label('Phone', class_="control-label")}
    ${form.text('phone',class_="form-control",maxlength=11, placeholder="Phone", value=user.phone)}
        ${validate_errors('phone')}
    </div>
        </div>
    </div>


    <fieldset><legend></legend>
        <div class="form-group">
   ${form.label('Nairabricks Profile address', class_="col-sm-4")}
       <div class="col-sm-8">
       https://nairabricks.com/profile/

    ${form.text('prefix',value=user.prefix, style='width:200px')}
        ${validate_errors('prefix')}
<p class="help-block"> e.g ${user.prefix}. Use only letters, underscores and numbers</p>
    </div>
  </div>
  <div class="row">
      <div class="col-md-6">
          <%doc>
          <div class="form-group">
   ${form.label('Website', class_="control-label")}
  <div class="col-sm-6">
   ${form.text('web',class_="form-control",placeholder='website',value=user.web)}
   </div>
  </div>
  </%doc>

        <div class="form-group">
   ${form.label('facebook', class_="control-label")}

    ${form.text('fb',class_="form-control",placeholder='e.g https://www.facebook.com/nairabricks',value=user.fb)}

  </div>
      </div>
      <div class="col-md-6">
          <div class="form-group">
   ${form.label('twitter', class_="control-label")}

    ${form.text('tw',class_="form-control",placeholder='e.g https://www.twitter.com/nairabricks',value=user.tw)}

  </div>
    <div class="form-group">
   ${form.label('linkedin', class_="control-label")}
    ${form.text('linkedin',class_="form-control",placeholder='e.g https://www.linkedin.com/...',value=user.linkedin)}
    </div>
      </div>
  </div>



        </fieldset>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-10">
      <button type="cancel" name='cancel' class="btn btn-default btn-flat">Cancel</button>
      <button type="submit" name="personal_submitted" class="btn btn-flat btn-pink">Submit</button>
    </div>
  </div>
${form.end()}
</div>