<div id="eandp">
${form.begin( method="post",url=request.route_url('about-update'), role="form", id="abtfm")}
    <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
  <div class="form-group">
    ${form.label("About", class_="control-label")}

      ${form.textarea('note',rows="10",id="editor",class_=" required form-control", content=user.note)}
  </div>
  
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-10">
      <button type="submit" class="btn btn-default">Cancel</button>
      <button type="submit" name="abt_submitted" class="btn btn-pink">Submit</button>
    </div>
  </div>
${form.end()}
</div>
