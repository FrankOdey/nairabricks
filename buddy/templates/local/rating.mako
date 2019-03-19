<%inherit file = "buddy:templates/base/base.mako"/>
<%block name="header_tags">
    ${parent.header_tags()}
    <style>
        li div,#overall div{
            display:inline;
        }
        body{background:#fff;}
    </style>
</%block>
<%block name="script_tags">
    ${parent.script_tags()}
<script>
    $(document).ready(function(){
        $(".rating").rating({'size':'xs',});
        $('#rating_form').validate();

            });
</script>
</%block>
<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <div class="wrapper">
            <h2 class="page-header">Rate and review ${locality.city_name.title()} in ${locality.state.name} <code>Ratings must not be less than 2 stars</code></h2>
            ${form.begin( method="post",id="rating_form", class_="form-horizontal")}
            <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
            %for ftype in ftypes:
            %if ftype.children:
                <div class="col-sm-4">
                        <strong>${ftype.name}</strong>
                        <ul class="list-unstyled" style="font-size: 11px">
                    %for child in ftype.children:
                        <li>${form.label(child.name)}:
                           ${form.text(child.name,class_="rating required")}
                                            </li>
                    %endfor
                            </ul>
                    </div>
            %endif
            %endfor
            <div class="row">
                <div class="col-sm-offset-2 col-sm-8">
            ${form.label('title', class_="control-label")}<span class="text-muted">(optional)</span>
            ${form.text('title', class_='form-control')}
            ${form.label('review', class_="control-label")}
            ${form.textarea('review',rows="5", class_='form-control required')}<br>
            ${form.submit('form_submitted','submit', class_="btn btn-warning")}
                </div>


                    </div>
               </div>
        </div>
    </div>
</div>