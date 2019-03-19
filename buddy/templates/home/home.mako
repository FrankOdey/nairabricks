<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/common/carousel.mako" import ="carousel,mobile_carousel"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>

        <%
            u=request.storage.url(background_pic)
            u=u.replace("\\","/")
          %>

<section style="background-image:url(${u}?${time});" id="home">

       <div class="container-fluid">
           <div class="row">
         ## <a href="${request.route_url('add_listings')}" class="pull-right" style="color: #de30f2; font-size:28px"><span class="glyphicon glyphicon-plus-sign "></span> Post property</a>
           <div class="col-md-10 col-md-offset-1" id="homesearch">
<h1>Find your dream home</h1>
<%include file="buddy:templates/listing/property/search.mako" />
    ##          <%include file="buddy:templates/listing/property/psearchform.mako" />
	      </div>
           </div>
           </div>
 <div class="" id="linksBellowSearchform">
    <div class="container">
        <div class="row">
            <div class="col-xs-12 ">
    <ul class="nav nav-list">
        <li><a href="${request.route_url('browse_category',category_id=1,category_name="Residential")}">Residential Properties</a></li>
        <li><a href="${request.route_url('browse_category',category_id=2,category_name="Commercial")}">Commercial Properties</a></li>
        <li><a href="${request.route_url('browse_category',category_id=3,category_name="Agricultural")}">Agricultural Properties</a></li>
        <li><a href="https://domore.ng">Find Artisans at DoMore.ng</a></li>
    </ul>

                </div>
        </div>
    </div>
    </div>
    </section>
    <section>
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
%if premium:
    <div id="featuredproducts">
        <div class="text-center">
        <h2 style="font-weight: bold; margin-bottom: 0;">Featured Listings</h2>
        <p class="text-muted">Best of the best</p>
            </div>
        <div  class="visible-lg visible-md">
    ${carousel(premium)}
    </div>
        <div class="visible-sm visible-xs">
        ${mobile_carousel(premium)}
        </div>
    </div>

%endif
            </div>
                </div>

            %if listings:
            <div class="row" id="latestproducts">
                <div class="col-md-12">
                    <div class="text-center">
        <h2 style="font-weight: bold; margin-bottom: 0;">Latest Listings</h2>
                        <p class="text-muted">Come back for more</p>
                    </div>
                        <div class="row">
        %for item in listings:
        <div class="col-md-3">
            ${zdetails(item)}
        </div>

        %endfor
                            </div>
            </div>
                </div>

                %endif
            </div>
        </section>
    <%doc>
    <div class="container">
    <div class="col-xs-12">
    <img src="/static/ads/bannerads.jpg" class="img-responsive" />
    </div>
    </div>

<div class="hand-down">
    <div class="container hidden-sm hidden-xs">
    <div class="col-xs-12 text-center bounce" style="font-size: 50px; color:#fff;padding: 10px">
        <a href="#down" class="scroll"><span class="glyphicon glyphicon-hand-down " style="color:#fff;"></span></a>
    </div>
    </div>
</div>


%if listings:
<div class="premium-listings">
<div class="container-fluid hidden-xs hidden-sm" id="down">
    <div class="row">
        <div class="col-md-12">

<div class="text-center">
    <p>Premium Properties <span class="glyphicon glyphicon-info-sign" style="color: #fff" data-toggle="tooltip"
              data-title="Our premium properties are currently listings with good enough pictures" data-placement="bottom"></span></p>
</div>

        <%include file="home-listing.mako"/>

        <p class="text-center"><a href="${request.route_url('all_property_listing')}" class="btn btn-site btn-sm">More properies &Gt;</a></p>

        </div>
            </div>
        </div>
<%include file="mobile-listing.mako"/>

</div>
    %endif
    </%doc>
<%doc>
<div class="features">
<div class="container">

<div class="text-center">
<h2 class="u-spacebottom20">Finally, home search made easy - for free</h2>
</div>
<div class="row">

    <div class="col-md-4">
        <div class="text-center pointer u-spacetop10 u-spacebottom20" onclick="location.href='${request.route_url('all_property_listing')}'">
    <span class="glyphicon glyphicon-search" style="font-size: 120px;"></span>
        <div class="h4"><b>Property Listings</b></div>
       <p><b>Explore your options, find here what your money can buy. Properties listed by estate agents in Nigeria</b></p>
         </div>
    </div>
     <div class="col-md-4">
    <div class="text-center pointer u-spacetop10 u-spacebottom20" onclick="location.href='${request.route_url('find_pros')}'">
<span class="glyphicon glyphicon-user" style="font-size: 120px;"></span>
        <div class="h4"><b>Professionals</b></div>
        <p><b>Meet Nairabricks Real Estate Network<br/> Professionals and request a contact</b></p>

</div>
    </div>
    <div class="col-md-4">
        <div class="text-center pointer u-spacetop10 u-spacebottom20" onclick="location.href='${request.route_url('blog_list')}'">
           <span class="glyphicon glyphicon-book" style="font-size: 120px;"></span>
        <div class="h4"><b>Advice</b></div>
        <p><b>Our blog posts covers all areas of real estate business in Nigeria</b></p>
    </div>
        </div>
</div>
</div>
    </div>

</%doc>
<div class="seolinks">
<div class="container">
<div class="row">
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading text-center" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
          Browse properties by State or Locality
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">

    %for state in states:
    <ul class="list-unstyled">
        %if len(state.listings.all())>0:
        <li><b><a href="${request.route_url('browse_state',state_name=state.name)}">${state.name.upper()}</a></b>
            <ul class="list-inline">
                %for city in state.lga.all():
                %if len(city.listings.all())>0:
                    <li><a href="${request.route_url('browse_region', state_name=state.name,region_id=city.id,region_name=city.name)}">${city.name}</a></li>
                    <span class="sep">.</span>
                %endif
                %endfor
            </ul>
            </li>
        %endif
    </ul>
    %endfor


</div>
</div>
        </div>

      </div>
</div>
</div>
    </div>
<div class="get-started-action">
    <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3 text-center">
            <h3>Want to post a property?</h3>
    <a href="${request.route_url('add_listings')}" class="btn btn-lg btn-site">LET'S GET STARTED</a>
            </div>
        </div>

</div>
</div>
<div class="container">
    <div class="hidden-sm hidden-xs">
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- FrontPageNbricks -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="3631671729"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
    </div>
<%doc>
<div class="fpblog">
    <div class="container">
        <div class="row">
            <%include file="fpbloglist.mako"/>
        </div>
    </div>
</div>
    </%doc>




<%doc>
<div class="container-fluid" >
    <div class="row">
        <div class="col-sm-12">
        <div class="hz_yt_bg">
           <div class="row">
    <div class="col-sm-8">
       <h4><span style="border-bottom:2px solid #d2322d;font-size: 18px"> About us</span></h4>
        <p>
            Nairabricks is dedicated to helping home owners, home buyers, home sellers, renters, real estate agents, mortgage
            professionals, landlords and property managers, find and share vital information about homes, real estate
            and home improvement.
            We have all the tools and valuable information you need to be successful in your home search process.
        </p>
        <a href="${request.route_url('about')}" class="btn btn-danger btn-sm">Read More &Gt;</a><br/>
<a class="twitter-timeline" href="https://twitter.com/Nairabricks" data-widget-id="728709929515782146">Tweets by @Nairabricks</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    </div>
        <div class="col-sm-4">
            <div class="fb-page" data-href="https://www.facebook.com/nairabricks/" data-tabs="timeline" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true">
            <div class="fb-xfbml-parse-ignore"><blockquote cite="https://www.facebook.com/nairabricks/">
                <a href="https://www.facebook.com/nairabricks/">Nairabricks Real Estate Network</a></blockquote></div></div>
        </div>
               </div>





<div class="text-center " style="padding-top:20px">
    %if not request.user:
<a href="${request.route_url('reg')}" class="btn btn-pink">Register with us now!</a><br>
        %endif
</div>
    </div>
    </div>

</div>
    </div>
</%doc>
<%block name="jivochat">
<!-- BEGIN JIVOSITE CODE {literal} -->
<script type='text/javascript'>
(function(){ var widget_id = 'P6kQK9QYrl';var d=document;var w=window;function l(){
var s = document.createElement('script'); s.type = 'text/javascript'; s.async = true; s.src = '//code.jivosite.com/script/widget/'+widget_id; var ss = document.getElementsByTagName('script')[0]; ss.parentNode.insertBefore(s, ss);}if(d.readyState=='complete'){l();}else{if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})();</script>
<!-- {/literal} END JIVOSITE CODE -->
</%block>