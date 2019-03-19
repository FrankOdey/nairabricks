<%inherit file="buddy:templates/dash/base.mako" />

<div class="row">
    <div class="col-sm-6">
    ${form.begin(method="post", class_="form-horizontal")}
    <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
    <div class="form-group">
       ${form.label('Group Name')}
       ${form.text('name',class_="form-control")}
    </div>

    <div class="form-group">
        ${form.submit('form_submitted',"Create Group", class_="btn btn-warning")}
     </div>
     ${form.end()}

        </div>
    <div class="col-sm-6">
    %if groups:
        <ol>
        %for g in groups:
        <li>${g.name}</li>
        %endfor
        </ol>
    %endif
        </div>
</div>