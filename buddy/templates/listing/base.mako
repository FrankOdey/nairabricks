<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%block name="header_tags">

<%block name="page_title"><title>Nairabricks.com - ${title or ''}</title></%block>

<link href="${request.static_url('buddy:static/uikit-2.20.3/css/uikit.almost-flat.min.css')}" rel="stylesheet">
<link href="${request.static_url('buddy:static/bootstrap/css/bootstrap.min.css')}" rel="stylesheet">
 <link href="${request.static_url('buddy:static/bootstrap/css/bootstrap-multiselect.css')}" rel="stylesheet">
<link href="${request.static_url('buddy:static/bootstrap-star-rating/css/star-rating.min.css')}" rel="stylesheet">
<link href="${request.static_url('buddy:static/cssm.css')}" rel="stylesheet">
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
</%block>
</head>
<body>
<%!
from webhelpers.html.tools import js_obfuscate
%>
<%include file="listingnav.mako"/>
<div class="container">
${self.flash_messages()}
</div>
${next.body()}
${self.footer()}
<%block name="script_tags">
<script src="${request.static_url('buddy:static/jquery.min.js')}"></script>
<script src="${request.static_url('buddy:static/uikit-2.20.3/js/uikit.min.js')}"></script>
 <script src="${request.static_url('buddy:static/uikit-2.20.3/js/components/notify.min.js')}"></script>
<script src="${request.static_url('buddy:static/bootstrap/js/bootstrap.min.js')}"></script>
<script src="${request.static_url('buddy:static/bootstrap/js/bootstrap-multiselect.js')}"></script>
<script src="${request.static_url('buddy:static/jquery.validate.min.js')}"></script>
<script src="${request.static_url('buddy:static/consumer.js')}"></script>
<script src="${request.static_url('buddy:static/step.js')}"></script>

<script>
$(function(){
$('#features').multiselect({
      maxHeight: 200,
      enableFiltering: true
    });
});
</script>

</%block>
</body>
</html>



<%def name="flash_messages()">
		% if request.session.peek_flash():
	
		<% flash = request.session.pop_flash() %>
		% for message in flash:
		
<div class="alert alert-${message.split(';')[0]} alert-dismissable col-md-12" style="border-radius:0">
	 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			
				${message.split(";")[1]}
			
		</div>
	
		% endfor
	
	% endif
</%def>
<%def name="footer()">
<div id="footer">
<div class="container" id="footer-wrapper">
&copy; 2015 <a href="http://www.zebrawaregroup.com">Zebraware Group</a>. All rights reserved.
</div>
</div>
</%def>