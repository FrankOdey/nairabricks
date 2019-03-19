


  <div class="form-group">
    ${form.label('headline',class_="col-sm-3 control-label")}
    <div class="col-sm-6">
      ${form.text("headline", class_="form-control", placeholder="", value=user.headline)}
        ${validate_errors('headline')}
    </div>
  </div>



    <fieldset>
        <div class="form-group">
   ${form.label('Nairabricks Profile address', class_="col-sm-4")}
       <div class="col-sm-8">
       https://nairabricks.com/profile/

    ${form.text('prefix', style='width:200px')}
        ${validate_errors('prefix')}
<p class="help-block"> e.g ${user.prefix}. Use only letters, underscores and numbers</p>
    </div>
  </div>
        </fieldset>