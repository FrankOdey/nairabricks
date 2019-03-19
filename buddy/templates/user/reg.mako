<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%block name="header_tags">
${parent.header_tags()}
<!-- Facebook Conversion Code for Registrations – Ephraim Ewele Anierobi 1 -->
<script>(function() {
var _fbq = window._fbq || (window._fbq = []);
if (!_fbq.loaded) {
var fbds = document.createElement('script');
fbds.async = true;
fbds.src = '//connect.facebook.net/en_US/fbds.js';
var s = document.getElementsByTagName('script')[0];
s.parentNode.insertBefore(fbds, s);
_fbq.loaded = true;
}
})();
window._fbq = window._fbq || [];
window._fbq.push(['track', '6031147107750', {'value':'0.00','currency':'USD'}]);
</script>
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=6031147107750&amp;cd[value]=0.00&amp;cd[currency]=USD&amp;noscript=1" /></noscript>

</%block>
<%block name="script_tags">
${parent.script_tags()}

  <script>
      $(function(){
    $('#regform').validate({
        rules:{
            email:{email:true}
        }
    });
    $('#is_pro').on('click', function(){
    check = $('#is_pro').is(':checked');
    $("#protype").toggle();

    });
    });

    </script>

</%block>

<div class="container">

<div class="row" id="registration-page">
    <div class="col-md-4 col-md-offset-4 ">
<div class="box box-primary">
    <div class="box-header">
        <h4 class="box-title"> Register</h4></div>
    <div class="box-body">
<div class="text-center "><p class="text-info h4">Real Estate Professionals<br>
    <span class="text-warning"><small>Join Nairabricks Growing Professionals</small></span></p></div>
<p style="color:red">${msg}</p>

        ${form.begin(url=action_url,id='regform', method="POST",class_="form-horizontal", role="form")}
	<input type="hidden" name="csrf_token" value="${get_csrf_token()}">

    <div class="form-group">
    		<div class="col-lg-12">
    	${form.label("email")}
    	${form.text("email", class_="form-control required", placeholder="Enter your email")}
    	${validate_errors("email")}
    	</div>
    	</div>
    	<div class="form-group">
    		<div class="col-lg-12">
    	${form.label("password")}
    	${form.password("password" ,class_="form-control required", placeholder="Enter password")}
    	${validate_errors("password")}
    	</div>
    	</div>
    <div class="form-group">
	<div class="col-lg-12">
	${form.label("Firstname")}
	${form.text("firstname",placeholder="Firstname", class_="form-control required")}
	${validate_errors("firstname")}

	</div>
	</div>
	<div class="form-group">
	<div class="col-lg-12">
	${form.label("Surname")}
	${form.text("surname",placeholder="Surname", class_="form-control required")}
	${validate_errors("surname")}

	</div>
	</div>

        <div class="form-group">
    		<div class="col-lg-12">
    	${form.checkbox("is_pro", label="I'm a real estate professional",id="is_pro")}
    	${validate_errors("is_pro")}
    </div>
    </div>
        <div id="protype" style="display: none">
            <div class="form-group ">
	<div class="col-lg-12">
	${form.label("Professional type")}
	${form.select("user_type_id", options = usertypes,prompt="Choose your professional type",class_="required form-control")}
	${validate_errors("user_type_id")}

	</div>
	</div>
        <div class="form-group">
             <div class="col-lg-12">
   ${form.label('Company name')}
##<p class="help-block">Which company do you work with</p>
    ${form.text('company_name',class_="form-control",placeholder='Company name')}
        ${validate_errors('company_name')}

    </div>
  </div>
            <%doc>
            <div class="form-group">
            <div class="col-lg-12">
   ${form.label('mobile')}

    ${form.text('mobile',class_="form-control ",maxLength=11,placeholder="mobile")}
        ${validate_errors('mobile')}
    </div>
     </div>
    <div class="form-group">
        <div class="col-lg-12">
   ${form.label('Phone')}

    ${form.text('phone',class_="form-control",maxLength=11, placeholder="Phone")}
        ${validate_errors('phone')}
    </div>
  </div>

            <div class="form-group">
                <div class="col-lg-12">
   ${form.label('Address')}
    ${form.text('address',class_="form-control", placeholder="Address")}
        ${validate_errors('address')}
    </div>
    </div>
             <div class="form-group">
                 <div class="col-lg-12">
   ${form.label('State')}
    ${form.select('state_id',class_="form-control required",options=states,prompt="Choose State")}
        ${validate_errors('state_id')}
    </div>
  </div>
    <div class="form-group">
        <div class="col-lg-12">
   ${form.label('City')}
    ${form.text('city',class_="form-control",placeholder='City')}
        ${validate_errors('city_id')}
    </div>
  </div>
            <div class="form-group">
                <div class="col-lg-12">
    ${form.label("About")}

      ${form.textarea('note',rows="10",id="editor",class_="form-control")}
    </div>
  </div>
  </%doc>

            </div><!--- close protype -->
        <div class="form-group">
            <div class="col-lg-12">
                <div class="g-recaptcha" data-sitekey="6LdFRkgUAAAAAO1WDPKSMVJy5h_qPchbKCBMaMsw"></div>
            </div>
        </div>
<div class="form-group">
	<div class="col-lg-12">
<button type="submit" name="form_submitted" class="btn btn-pink btn-flat pull-right">Sign Up for Free</button>
</div>
</div>
	${form.end()}


        </div>
    <div class="box-footer">
        Already have one? <a href="${request.route_url('login')}">login</a>
    </div>
</div>

</div>
    </div>
</div>
