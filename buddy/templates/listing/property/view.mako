<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/common/listing_detail_carousel.mako" import="carousel,carousel_mobile"/>
<%namespace file="buddy:templates/listing/property/pviewinclude.mako" import="controls"/>
<%!
    import random
    from webhelpers.html import literal

    %>

<%block name="header_tags">
    <meta property="og:url"           content="${request.route_url('property_view', name=listing.name)}" />
    <meta property="og:type"          content="website" />
    <meta property="og:title"         content="${listing.title}" />
    <meta property="og:description"   content="${listing.excerpt}" />
    <meta property="fb:app_id" content="1649187415295923"/>
    %if len(listing.pictures.all())>0:
        <%
        picture_rel = listing.pictures.all()
        d = [pic.filename for pic in picture_rel]
          %>
     <meta name="twitter:image" content="${request.storage.url(d[0])}">
     <meta property="og:image" content="${request.storage.url(d[0])}"/>
    %else:
        <meta property="og:image" content="/static/nopics.jpg"/>
    %endif
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@nairabricks">
<meta name="twitter:creator" content="@nairabricks">
<meta name="twitter:title" content="${listing.title}">
    <meta name="twitter:description" content="${listing.excerpt}">

<!-- Add fancyBox -->
<link rel="stylesheet" href="/static/fancybox/source/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen" />

<style>
.complete{
    display:none;
}

.moretext, .lesstext{
    background:lightblue;
    color:navy;
    font-size:13px;
    padding:3px;
    cursor:pointer;
}
        </style>
</%block>
<%block name="script_tags">
    <script src="${request.static_url("buddy:static/sticky.js")}"></script>
  <script>
      $(function(){
  $("#sticker").sticky({topSpacing:0});
    });

    </script>
<script type="text/javascript" src="/static/fancybox/source/jquery.fancybox.pack.js?v=2.1.5"></script>
        <script>

        $(".moretext").click(function(){
            $(this).hide();
            $(".complete").show();
            $(".lesstext").show();
        });
        $(".lesstext").click(function(){
                    $(this).hide();
                    $(".complete").hide();
                    $(".moretext").show();
                    $(".lesstext").hide();
                });
    </script>

    <script>
        $(document).ready(function(){
            $(".agentForm").validate({
                rules:{
                    email:{email:true},
                    mobile:{digits:true}
                },
                submitHandler: function(form) {
                        form.submit();
                    }
            });
         $(".fancybox").fancybox({
		padding:5
	});

        });
        document.getElementById('FBshare').onclick = function() {
        FB.ui({
        method: 'share',
        display: 'popup',
        href: '${request.route_url('property_view',name=listing.name)}'
    }, function(response){});
}
    </script>
</%block>
<div class="container">
<section class="content-header">
    <div class="row">
        <div class="col-md-6" style="margin-top: -20px">
            <h1>${listing.listing_type} <small>${listing.title}</small></h1>
        </div>
        <div class="col-md-6 hidden-xs hidden-sm" >
            ##   <%include file="buddy:templates/listing/property/search.mako" />
    <ol class="breadcrumb" style="position: relative;float:none; top:0px" itemscope itemtype="http://schema.org/BreadcrumbList">
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
   </li>
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('all_property_listing')}"><span itemprop="name">Listings</span></a>
        </li>
        %if listing.listing_type.lower()=="for rent":
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('search_properties')}?type=For+Rent"><span itemprop="name">for rent</span></a>
        </li>
            %elif listing.listing_type.lower()=="for sale":
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('search_properties')}?type=For+Sale"><span itemprop="name">for sale</span></a>
        </li>
            %elif listing.listing_type.lower()=="short let":
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('search_properties')}?type=Short+Let"><span itemprop="name">short let</span></a>
        </li>
        %endif
            <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_state',state_name=listing.state.name)}">
              <span itemprop="name">${listing.state.name}</span></a>
        </li>
         %if listing.lga:
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem">
            <a itemprop="item" href="${request.route_url('browse_region',region_id=listing.lga.id,region_name=listing.lga.name,state_name=listing.lga.state.name)}">
            <span itemprop="name">${listing.lga.name}</span></a>
        </li>
        %endif
        %if listing.district:
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem">
            <a itemprop="item" href="${request.route_url('browse_area',area_id=listing.district.id,area_name=listing.district.name,region_name=listing.lga.name,state_name=listing.state.name)}">
            <span itemprop="name">${listing.district.name}</span></a>
        </li>
        %endif
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${listing.title}</span>
        </li>
    </ol>
        </div>
    </div>
    </section>
<section class="content">
    <%doc><div style="margin:5px;background:#fff">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- ListingViewPageTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="7289815327"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div></%doc>
    <div class="row" id="listing-view">
        <div class="col-md-8 remove-padding">

            <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#photos" data-toggle="tab" aria-expanded="true">Details</a></li>
              <li class=""><a href="#contact-agent" data-toggle="tab" aria-expanded="false">Contact Agent</a></li>
            </ul>
            <div class="tab-content">


                <div class="tab-pane active" id="photos">
                    %if len(listing.pictures.all())>1:
                    <p> <span class="label label-info">Click on image to view larger</span></p>
                    <div class="visible-md visible-lg">
                    ${carousel(listing)}
                    </div>
                        <div class="visible-sm visible-xs">
                    ${carousel_mobile(listing)}
                    </div>
                        %else:
                        %if len(listing.pictures.all())>0:
                            <div class="row">
                                <div class="col-md-offset-3 col-md-6">
                                <img src="${request.storage.url(listing.pictures[0].filename)}" class="img-responsive" alt="${listing.title} image">
                            </div>
                            </div>
                            %else:
                            %if listing.category.name.lower() in ['agricultural land','residential land','commercial land','hotel sites','industrial land']:
                                <div class="row">
                                <div class="col-md-offset-3 col-md-6">
                            <img class="img-responsive" src="${request.static_url('buddy:static/nopicsland.jpg')}" alt="no image">
                            </div>
                            </div>
                            %else:
                            <div class="row">
                                <div class="col-md-offset-3 col-md-6">
                            <img class="img-responsive" src="${request.static_url('buddy:static/nopics.jpg')}" alt="no image">
                            </div>
                            </div>
                            %endif
                        %endif

                        %endif
                    <hr>
                    <div class="row">
                        <div class="col-md-8">
                             <h4 class="listing-address"><span class="fa fa-map-marker"></span>
    %if listing.show_address:
        ${listing.address.title()}</h4>
%else:
        Call agent for addresss</h1>
%endif
                            <span class="label label-info">
                                ${listing.property_extra.bedroom or 0} beds<span class="sep">·</span>
                ${listing.property_extra.bathroom or 0} baths<span class="sep">·</span> ${listing.property_extra.area_size} sqm
                            </span>
                            <div class="table-responsive" style="margin-top: 10px">
<table class="table">
<tr id="social">
##<td><a href=""><span class="glyphicon glyphicon-envelope"></span>
##  Email Alerts</a></td>
<td>${self.tweet()}</td>
<td><div class="fb-send" data-href="${request.route_url('property_view',name=listing.name)}" data-colorscheme="light"></div></td>
<td><a class="btn btn-primary btn-xs" id="FBshare"><span class="fa fa-facebook-official"></span> Share</a></td>
</tr>
</table>
</div>

                        </div>
                        <div class="col-md-4 text-right">
                            <p class="listing-type">${listing.listing_type.upper()}</p>
                            <p class="price-info price">${listing.price}</p>
                            <span class="badge badge-default">Listing#: ${listing.serial}</span>
                        </div>
                        <div class="text-center">
                        ${controls(listing)}
                            </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-md-12">
                           ${literal(listing.body.replace('\n',"<br>"))}
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div style="margin:5px;background:#fff">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- ListingViewPageTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="7289815327"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
                            <h3>Facts and Features</h3>
                            <%include file="property_attributes.mako"/>
                            <%include file="features_attributes.mako"/>
                        </div>
                    </div>

                </div>
                <div class="tab-pane" id="contact-agent">
                    <div class="panel panel-default">

    <div class="panel-heading">Learn more about this property</div>
        <div class="panel-body">
             <div class="row">
                 <div class="col-md-6">
                     <i>This listing is brought to you by:</i>
       %if listing.user.company_name:
            <div class="h5"><strong>${listing.user.company_name}</strong></div>
        %endif

         %if listing.user.company_logo:
           <img src="${request.storage.url(listing.user.company_logo)}" alt="company logo" class="img-responsive" style="max-width: 200px"/>
        %endif
    <%include file="userdetailbadge.mako"/>
                     <%include file="contact_agent.mako"/>
                 </div>
                 <div class="col-md-6">

                            </div>
                        </div>

##<%include file="contact_agent.mako"/>
##view ${listing.user.fullname}'s <a href="${request.route_url('user_questions', prefix=listing.user.prefix)}">Questions</a>,
##      <a href="${request.route_url('user_blog', prefix=listing.user.prefix)}">Blog Posts</a> and
##       <a href="${request.route_url('user_answers', prefix=listing.user.prefix)}">Answers</a>
       ## <a href="${request.route_url('add_listings')}"><img src="${request.static_url('buddy:static/nairabricks-fb.jpg')}" class="img-responsive" style="margin-top:20px;border:2px solid #003368"/></a>


    </div>
</div>
                </div>
            </div>
            </div>

        </div>
        <div class="col-md-4">
            <div class="box box-primary">
                <div class="box-header">
                    <h4 class="box-title">Marketer</h4>
                </div>

            <div class="box-body">
                <i>This listing is brought to you by:</i>
       %if listing.user.company_name:
            <div class="h5"><strong>${listing.user.company_name}</strong></div>
        %endif

         %if listing.user.company_logo:
           <img src="${request.storage.url(listing.user.company_logo)}" alt="company logo" class="img-responsive" style="max-height: 120px"/>
        %endif
    <%include file="userdetailbadge.mako"/>
                    ## <a href="#" data-toggle="modal" data-target="#contactAgent" class="btn btn-pink">Email Agent</a>
            </div>
            </div>
            <div style="margin:5px;background:#fff">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- ListingViewPageTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="7289815327"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
        </div>
    </div>
</section>
</div>

<%def name="tweet()">
<a href="https://twitter.com/share" class="twitter-share-button" data-count="none">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</%def>