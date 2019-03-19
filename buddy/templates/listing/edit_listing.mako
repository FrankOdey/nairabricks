<%inherit file = "buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%!
from webhelpers.html.tools import js_obfuscate
%>

<%block name="script_tags">
${parent.script_tags()}
<script src="${request.static_url('buddy:static/step.js')}"></script>
<script>
    function sortSelectOptions(selector, skip_first) {
    var options = (skip_first) ? $(selector + ' option:not(:first)') : $(selector + ' option');
    var arr = options.map(function(_, o) { return { t: $(o).text(), v: o.value, s: $(o).prop('selected') }; }).get();
    arr.sort(function(o1, o2) {
      var t1 = o1.t.toLowerCase(), t2 = o2.t.toLowerCase();
      return t1 > t2 ? 1 : t1 < t2 ? -1 : 0;
    });
    options.each(function(i, o) {
        o.value = arr[i].v;
        $(o).text(arr[i].t);
        if (arr[i].s) {
            $(o).attr('selected', 'selected').prop('selected', true);
        } else {
            $(o).removeAttr('selected');
            $(o).prop('selected', false);
        }
    });
}
    $(function(){

sortSelectOptions('#lga_id', true);
    $('#title').on('focus', function(){
    $('#title-tip').css('background', '#ccc');
    }).on('blur', function(){
    $('#title-tip').css('background','#fff');
    });
    var category_id = $('#category_id');
    category_id.on('focus', function(){
    $('#category-tip').css('background', '#ccc');
    }).on('blur', function(){
    $('#category-tip').css('background','#fff');
    });

    $('#address').on('focus', function(){
    $('#address-tip').css('background', '#ccc');
    }).on('blur', function(){
    $('#address-tip').css('background','#fff');
    });
        var selected = $( "#subcategory_id option:selected" ).text();
        if (selected==='Commercial Land'|| selected==='Residential Land'||
                selected==="Agricultural Land"|| selected==="Industrial Land" || selected==="Hotel Sites"){
            $("#house").hide('slow');
            $("#house").find('input:text').val('');
            $("#featureset").find("input[type='checkbox']").prop('checked', false);
            $("#featuresetPanel").hide('slow');
        }
        else {
            $('#house').show('slow');
            $("#featuresetPanel").show('slow');

        }

    $('#collapseOptional').on('hidden.bs.collapse', function () {
    $('#more-options').html('More options'+"<span class='glyphicon glyphicon-circle-arrow-down'></span>");
    $(this).find('input:text').val('')
})
        $('#collapseOptional').on('show.bs.collapse', function () {
    $('#more-options').html('Hide options'+"<span class='glyphicon glyphicon-circle-arrow-up'></span>");
})
        $('#featureset').on('hidden.bs.collapse', function () {
    $('#featuresetToggle').html('Click to add Features to property'+"<span class='glyphicon glyphicon-circle-arrow-down'></span>");
    $("#featureset").find("input[type='checkbox']").prop('checked', false);
})
        $('#featureset').on('show.bs.collapse', function () {
    $('#featuresetToggle').html('Clear & Hide features of property'+"<span class='glyphicon glyphicon-circle-arrow-up'></span>");
})
    });
</script>
</%block>
<section class="content-header">
      <h1>
        Edit this property
      </h1>
      <ol class="breadcrumb">
        <li><a href="/"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Edit property</li>
      </ol>
    </section>
<section class="content">
               ${form.begin(method="post",id="wizard_start")}
               <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Edit Property Details</h3>
                </div>
                <div class="box-body">
                    <fieldset>
                        <div class="row">
                            <div class="col-md-9">
                                <div class="form-group">
                                    ${form.label('title')}<span class="req">*</span>
                                    ${form.text('title',placeholder="e.g Well furnished 4 Bedroom duplex for sale in Lekki",class_="form-control required", maxlength=100)}
                                    ${validate_errors('title')}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                ${form.label('Listing type', class_="control-label")}<span class="req">*</span>
                                ${form.select('listing_type',options=[('For sale','For Sale'),('For rent','For Rent'),('Short let','Short let')],prompt="Please Select",
                                class_="form-control required")}
                                ${validate_errors('listing_type')}
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                ${form.label('property category', class_="control-label")}<span class="req">*</span>
                                ${form.select('category_id',disabled='disabled', options=categories,selected_value=listing.category.parent.id,class_="form-control required")}
                                ${validate_errors('category_id')}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    ${form.label('choose a subcategory',class_="control-label")}<span class="req">*</span>
                                    ${form.select('subcategory_id', options=subcategories,selected_value = listing.category.id,class_="form-control required")}
                                    ${validate_errors('subcategory_id')}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                            ${form.label('Transaction type')}<span class="req">*</span>
                            ${form.select('transaction_type', options=[('New Property'),('ReSale'),('Foreclosure')],
                            class_="form-control required")}
                            ${validate_errors('transaction_type')}
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="form-group">
                                    ${form.label('Available From')}<span class="text-muted">(optional)</span>
                                    ${form.text('available_from',class_="form-control", placeholder="e.g Now")}
                                ${validate_errors('available_from')}
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    ${form.label('Select state', class_="control-label")}<span class="req">*</span>
                                    ${form.select('state_id', options=states,prompt="Select state",class_="form-control required state_id")}
                                ${validate_errors('state_id')}
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    ${form.label('Region', class_="control-label")}<span class="req">*</span>
                                    ${form.select('lga_id',options=lgas,selected_value=listing.lga_id,class_="form-control required lga_id")}
                                    ${validate_errors('lga_id')}
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    ${form.label('Area', class_="control-label")}<span class="req">*</span>
                                ${form.text('dist',class_="form-control required", maxlength=20)}
                                </div>
                            </div>
                        </div>
                    </fieldset>
                     <fieldset id="house">
                         <div class="row">
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('bedroom')}<span class="req">*</span>
                                    ${form.text('bedroom',maxlength=3,placeholder="e.g 4",class_="form-control required")}
                                    ${validate_errors('bedroom')}
                                 </div>
                             </div>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('bathroom')}<span class="req">*</span>
                                    ${form.text('bathroom',maxlength=3,class_="form-control required")}
                                    ${validate_errors('bathroom')}
                                 </div>
                             </div>
                             <%doc>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('Land size')}(m&sup2;)<span class="req">*</span>
                                    ${form.text('area_size',placeholder="e.g 420",maxlength=6,class_="form-control required")}
                                    ${validate_errors('area_size')}
                                 </div>
                             </div>
                             </%doc>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('Covered area')}(m&sup2;)<span class="text-muted">(optional)</span>
                                    ${form.text('covered_area',placeholder="e.g 240",maxlength=6,class_="form-control")}
                                     ${validate_errors('covered_area')}
                                 </div>
                             </div>

                         </div>
                         <a class="btn btn-xs btn-pink" id="more-options" role="button" data-toggle="collapse"
                            href="#collapseOptional" aria-expanded="false" aria-controls="collapseOptional">More Options <span class="glyphicon glyphicon-circle-arrow-down"></span> </a>
                    <div class="collapse" id="collapseOptional">
                        <div class="row">
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('Total room')}<span class="text-muted">(optional)</span>
                                    ${form.text('total_room',maxlength=3,class_="form-control")}
                                    ${validate_errors('total_room')}
                                 </div>
                             </div>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('Built year')}<span class="text-muted">(optional)</span>
                                    ${form.text('year_built',maxlength=4,class_="form-control")}
                                    ${validate_errors('year_built')}
                                 </div>
                             </div>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.label('Car Spaces')}<span class="text-muted">(optional)</span>
                                    ${form.text('car_spaces',maxlength=3,class_="form-control")}
                                    ${validate_errors('car_spaces')}
                                 </div>
                             </div>
                             <div class="col-md-3">
                                 <div class="form-group">
                                     ${form.checkbox('furnished',label='Furnished')}
                                    ${validate_errors('furnished')}
                                 </div>
                             </div>
                         </div>
                         <div class="row">
                             <div class="col-md-4">
                                 <div class="form-group">
                                     ${form.label('Floor Number')}<span class="text-muted">(optional)</span>
                                    ${form.text('floor_no',maxlength=3,class_="form-control")}
                                    ${validate_errors('floor_no')}
                                 </div>
                             </div>
                             <div class="col-md-4">
                                 <div class="form-group">
                                     ${form.label('Total Floor')}<span class="text-muted">(optional)</span>
                                    ${form.text('total_floor',maxlength=3,class_="form-control")}
                                    ${validate_errors('total_floor')}
                                 </div>
                             </div>
                             <div class="col-md-4">
                                 <div class="form-group">
                                      ${form.checkbox('serviced',label='Serviced')}
                                    ${validate_errors('serviced')}
                                 </div>
                             </div>
                         </div>
                    </div>
                    </fieldset>
                    <fieldset id="land">
                        <div class="row">
                            <div class="col-md-4">
                                    <div class="form-group">
                                     ${form.label('Land size')}(m&sup2;)<span class="req">*</span>
                                    ${form.text('area_size',placeholder="e.g 420",maxlength=6,class_="form-control required")}
                                    ${validate_errors('area_size')}
                                 </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                  ${form.label('Price')}<span class="req">*</span>
                                    ${form.text('price',placeholder="e.g 600000",class_="form-control price required")}
                                    ${validate_errors('price')}
                                ${form.checkbox("price_available",label="Price available")}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    ${form.label('Deposit')}<span class="text-muted">(optional)</span>
                                    ${form.text('deposit',placeholder="e.g 50%",class_="form-control")}
                                    ${validate_errors('deposit')}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    ${form.label('Agent Commission')}<span class="text-muted">(optional)</span>
                                    ${form.text('agent_commission',placeholder="e.g 10%",class_="form-control")}
                                    ${validate_errors('agent_commission')}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                ${form.label('Price Condition')}<span class="text-muted">(optional)</span>
                                ${form.text('price_condition',placeholder="e.g Negotiable",class_="form-control")}
                                ${validate_errors('price_condition')}
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    ${form.label("address", class_="control-label")}<span class="req">*</span>
                                    ${form.text("address",class_="form-control required address-popover", maxlength=120)}
                                    ${validate_errors('address')}
                                    ${form.checkbox("show_address",label=" Show this address")}
                                </div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset>

                                <div class="form-group">
                                    ${form.label('description',class_="control-label")}<span class="req" >*</span>
                                    ${form.textarea('body',rows="9",class_="ckeditor form-control required", style="white-space:pre;")}
                                <span id="helpBlock" class="help-block">Your description should be short.
                                    No phone number,email or any contact info should be in description.</span>

                        </div>
                    </fieldset>

                    <fieldset>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <button type="cancel" name="cancel" class="btn bg-black">Cancel</button>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">

                                    <button type="submit" name="submit" class="btn bg-purple pull-right next-step" >Save & Add pictures</button>
                                </div>
                            </div>
                        </div>
                    </fieldset>

            </div>
        </div>
               ${form.end()}
</section>