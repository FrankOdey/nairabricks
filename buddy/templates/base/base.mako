##<%namespace file="bootstrap_css.mako" import="bootstrap_css"/>
##<%namespace file="uikit_css.mako" import="uikit_css"/>
##<%namespace file="jquery.mako" import="jquery"/>
##<%namespace file="jqueryform.mako" import="jqueryform"/>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="keyword" content="${title or ''}">
    <%block name="meta_desc">
    </%block>


<title>${title} | Nairabricks</title>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/bootstrap.css')}">
  <!-- Skin -->
  <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/skins/skin-purple.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/skins/skin-purple.css')}">
    </noscript>
    <!-- Theme style -->
    <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/AdminLTE.css')}" media="none" onload="if(media!='all')media='all'">
    <noscript>
        <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/css/AdminLTE.css')}">
    </noscript>
##<link href="${request.static_url('buddy:static/jquery.auto-complete.css')}" rel="stylesheet"  type="text/css" media="none" onload="if(media!='all')media='all'">
    <link rel="stylesheet" href="${request.static_url('buddy:static/consumer.css')}" >
<link rel="shortcut icon" href="${request.static_url('buddy:static/favicon.ico')}" />
##<link href="${request.static_url('buddy:static/consumer.css')}" rel="stylesheet"  type="text/css">
<style>
    .content-wrapper {
    background-color: #fff;
}
</style>
<%block name="header_tags">

</%block>
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script>
        if (document.location.hostname === "www.nairabricks.com"||document.location.hostname==='nairabricks.com') {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-52737065-1', 'auto');
  ga('send', 'pageview');
             }

/*
  $(window).load(function() {      //Do the code in the {}s when the window has loaded
  $("#loader").fadeOut("fast");  //Fade out the #loader div
});
*/
</script>

    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-2823597361043659",
    enable_page_level_ads: true
  });
</script>

    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>

<body class="layout-top-nav skin-purple">

<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '1649187415295923',
      cookie     : true,
      xfbml      : true,
      version    : 'v3.1'
    });

    FB.AppEvents.logPageView();

  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
</script>

##<%include file="list-top.mako"/>

${next.body()}


${self.footer()}


<%block name="blog_categories"></%block>
 <!-- jQuery 3 -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery.min.js')}"></script>
<!-- jQuery UI 1.11.4 -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery-ui.min.js')}"></script>

<!-- Bootstrap 3.3.7 -->
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

<!-- Slimscroll -->
<script src="${request.static_url('buddy:static/dashboard-asset/jquery-slimscroll/jquery.slimscroll.min.js')}" async></script>
<!-- FastClick -->
##<script src="${request.static_url('buddy:static/dashboard-asset/fastclick/lib/fastclick.js')}"></script>
<!-- AdminLTE App -->
<script src="${request.static_url('buddy:static/dashboard-asset/js/adminlte.min.js')}" async></script>
##<script src="${request.static_url('buddy:static/bootstrap-star-rating/js/star-rating.min.js')}"></script>
<script src="${request.static_url('buddy:static/jqueryform.js')}" async></script>
   ## <script src="${request.static_url('buddy:static/blockui.js')}"></script>
<script src="${request.static_url('buddy:static/jquery.validate.min.js')}" async></script>

<script src="${request.static_url('buddy:static/bootstrap/js/bootstrap-multiselect.js')}" async></script>
<script src="${request.static_url('buddy:static/jquery.auto-complete.min.js')}" async></script>
<script src="${request.static_url('buddy:static/priceformat.js')}" async></script>
<script src="${request.static_url('buddy:static/consumer.js')}" async></script>
<%block name="script_tags">
</%block>
<script>
        $(function(){
            $('[data-toggle="tooltip"]').tooltip();
            $('[data-toggle="popover"]').popover();
            var xhr;
           $('input[name="cities_auto"]').autoComplete({
            minChars:2,
           source: function(term, response){ try { xhr.abort(); } catch(e){}
        xhr = $.getJSON('/listings/cities_autocomplete', { cities_auto: term }, function(data){ response(data); });
    }
});


        });

        </script>
<script type="text/javascript">
	(function() {
		var css = document.createElement('link');
		css.href = "${request.static_url('buddy:static/dashboard-asset/font-awesome/css/font-awesome.min.css')}";
		css.rel = 'stylesheet';
		css.type = 'text/css';
		document.getElementsByTagName('head')[0].appendChild(css);
	})();
</script>
##<%include file="navoffcanvas.mako"/>
<%block name="jivochat"></%block>
</body>
</html>

<%def name="flash_messages()">
		% if request.session.peek_flash():

		<% flash = request.session.pop_flash() %>
		% for message in flash:

<div class="alert alert-${message.split(';')[0]} alert-dismissible col-xs-12">
	 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
				${message.split(";")[1]}
		</div>

		% endfor

	% endif
</%def>


<%def name="footer()">
    <% import datetime
        %>

<footer>
<address class="appFooter-contact pageSection-grey">
    <div class="container">

<div class="row">
    <div class="col-xs-9" style="padding-top:5px">
                           <span class="find-help">Get help finding a property:</span>
                            <span class="find-help">info@nairabricks.com</span>
                       </div>
                       <div class="col-xs-3 text-right" style="padding-top:5px">
                           <ul class="list-inline find-help">
                               <li><a href="http://www.facebook.com/nairabricks" target="_blank"><i class="fa fa-lg fa-facebook"></i></a> </li>
                               <li><a href="http://www.twitter.com/nairabricks" target="_blank"><i class="fa fa-lg fa-twitter"></i> </a></li>

                           </ul>
                       </div>
</div>
        </div>
    </address>
    <div class="container">
        <div class="row">
        <div class="col-md-12">
 <a href="/"><img src="/static/logo-2.png" width="200" class="img-responsive"></a>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <ul class="nav nav-list">
                <li>&copy; ${datetime.date.today().year} Nairabricks</li>
        <li ><a href="${request.route_url('about')}">About</a></li>
        <li ><a href="${request.route_url('contact')}">Contact us</a></li>
        <li ><a href="${request.route_url('terms')}">Terms of use</a></li>
        <li ><a href="${request.route_url('privacy')}">Privacy policy</a></li>
        <li><a href="${request.route_url('goodneighbor')}">Good neighbor policy</a></li>
        <li><a href="${request.route_url('listing_quality')}">Listings quality policy</a></li>
    </ul>
        </div>
        </div>

</div>
</footer>
</%def>