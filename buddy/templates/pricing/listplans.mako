<%inherit file="buddy:templates/dash/base.mako"/>


%if plans:
    <section>

   %for plan in plans:
        <h6><a href="${request.route_url('edit_plan', id=plan.id)}">${plan.name}</a></h6>
   %endfor


    </section>
%endif
<section>
    <h4>Create A Plan</h4>
  ${self.create_plan()}
</section>

<%def name="create_plan()">
      <div class="col-md-6">
${form.begin(method="post",class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
  <div class="form-group">
      ${form.label("Name")}
      ${form.text('name', class_="form-control")}
  </div>
          <div class="form-group">
      ${form.label("Plan Code")}
      ${form.text('code', class_="form-control")}
  </div>
        <div class="form-group">
            ${form.label("Max Listing")}
      ${form.text('max_listings', class_="form-control")}
  </div>
        <div class="form-group">
            ${form.label("Price per month")}
      ${form.text('price_per_month', class_="form-control")}
  </div>
        <div class="form-group">
            ${form.label("Max Premium Listings")}
      ${form.text('max_premium_listings', class_="form-control")}
  </div>
        <div class="form-group">
            ${form.label("Max Blog Posts")}
      ${form.text('max_blogposts', class_="form-control")}
  </div>
        <div class="form-group">
            ${form.label("Max Premium Blog Posts")}
      ${form.text('max_premium_blogposts', class_="form-control")}
  </div>
        <div class="checkbox">
            <label>
        ${form.checkbox('featured_profile')} Featured Profile
                </label>
        </div>

     <div class="form-group">
    ${form.submit('form_submitted', class_='btn btn-pink')}
     </div>
    ${form.end()}
        </div>
</%def>