<%namespace file="buddy:templates/base/base.mako" import='flash_messages'/>

<div class="container">
<div class="row">
	<div class="col-sm-3">
<a href="${request.route_url('home')}"><img src="/static/nairabricksid.png" id="logo" class="hidden-print"></a>
	</div>
	<div class=" col-sm-6 text-center">
${flash_messages()}
##<div id="loader" class="text-center hidden-xs hidden-sm">
##<img src="/static/ajax-loader.gif" width="20"/>
##</div>
	</div>
	<div class="col-sm-3">

    </div>
</div>
<%doc>
    <div class="row">
<div class="col-sm-12 col-md-12">
	<%include file="buddy:templates/listing/property/searchform.mako" />
</div>
</div>
</%doc>
</div>

