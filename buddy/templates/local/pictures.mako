


<div id="picModal" class="uk-modal">
            <div class="uk-modal-dialog">
                <a class="uk-modal-close uk-close"></a>
                <div class="uk-modal-header">
                <h4>Upload picture of ${locality.city_name}</h4>
                    <p class="text-danger">Ensure the picture you are uploading is of this city.</p>
                </div>

        ${form.begin(id="picForm",url = request.route_url('add_city_pictures', name=locality.name),multipart=True, method="post", role="form")}
        <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
       <div class="form-group">
        ${form.label('Caption', class_="control-label")}
        ${form.text('title',class_="form-control required")}
        </div>
        <div class="form-group">
        ${form.label('Categorize Picture', class_="control-label")}
        ${form.select('category_id',options=cate,prompt="Choose picture category",class_="form-control required")}
        </div>
        <div class="form-group">
        ${form.label("Upload picture", class_="control-label")}
          ${form.file(name="filename",  class_="form-control required",accept="image/*")}
        </div>

        <div class="uk-modal-footer">
        <div class="form-group">
        ${form.submit('form_submitted',value="Submit", class_="uk-button uk-button-primary")}
        </div>

        </div>
         ${form.end()}
</div>
</div>
