<%inherit file = "buddy:templates/base/layout.mako"/>
<%block name="script_tags">
<script src="${request.static_url("buddy:static/sticky.js")}"></script>
  <script>
      $(function(){
  $("#sticker").sticky({topSpacing:0});
    });

    </script>

</%block>
<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>
<%namespace file="buddy:templates/listing/property/all.mako" import="details"/>

<div class="container">
    <ul class="breadcrumb hidden-xs" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('all_property_listing')}"><span itemprop="name">Property Listings</span></a>
        <meta itemprop="position" content="2" /></li>
        %if lga_id and state_id:
            <%
                from buddy.models.properties_model import LGA
                lga = LGA.get_by_id(lga_id)
                %>
          <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_state',state_name=lga.state.name)}">
              <span itemprop="name">${lga.state.name}</span></a>
        <meta itemprop="position" content="3" /></li>
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_region',region_id=lga.id,region_name=lga.name,state_name=lga.state.name)}">
            <span itemprop="name">${lga.name}</span></a>
        <meta itemprop="position" content="4" /></li>

        %elif state_id and not lga_id:
            <%
                from buddy.models.properties_model import State

                state = State.get_by_id(state_id)
                %>
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_state',state_name=state.name)}"><span itemprop="name">${state.name}</span></a>
        <meta itemprop="position" content="3" /></li>
            %endif
        %if ptype:
            <%
                from buddy.models.properties_model import PropertyCategory

                category = PropertyCategory.get_by_id(ptype)
                %>
        <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_category',category_id=category.id,category_name=category.name)}"><span itemprop="name">${category.name}</span></a>
        <meta itemprop="position" content="5" /></li>
            %endif

    </ul>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- propertySearchTop -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="3509858383"
     data-ad-format="auto"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
<div class="row">
<div class="col-md-4 col-md-push-8">
    <div class="hz_yt_bg">
        <a href="#" id="show-advanced" class="visible-sm visible-xs">Toggle Advanced Filter Options</a>
        <div id="advanced-search" style="display: none">
    <%include file="buddy:templates/listing/property/psearch.mako" />
            </div>
            <div class="visible-md visible-lg">
    <%include file="buddy:templates/listing/property/psearch.mako" />
            </div>
    </div>
        <div class="hidden-sm hidden-xs" >
        <div class="hz_yt_bg" id="sticker" >
            
            <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- PropertySearch sidebar -->
<ins class="adsbygoogle"
     style="display:inline-block;width:300px;height:600px"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="7847546886"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
        </div>
        </div>
            </div>
	<div class="col-md-8 col-md-pull-4 " >
%if paginator:
<div class="hz_yt_bg" >
    <p>Your search returned ${total} properties</p>
    </div>
	
    %for item in paginator.items:
  %if loop.index==3 or loop.index==6:
  <div class="row">
    <div class="col-sm-12">
      <div class="hz_yt_bg fill-div">
      <div class="text-center" style="border-top: 1px solid #f4f4f4;border-bottom:1px solid #f4f4f4">
<small> Advertisement </small>
  </div>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-format="fluid"
     data-ad-layout="image-side"
     data-ad-layout-key="-fg+5r+6l-ft+4e"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="6019459890"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
      </div>
    </div>
  </div>
  %endif

<div class="row">
${details(item)}
</div>

  
    %endfor

${paginator.pager(
'$link_previous ~3~ $link_next',
    link_attr={"class":"btn btn-sm btn-pink"},
    curpage_attr={"class":"btn btn-sm btn-default disabled"},
    symbol_next="Next",
    symbol_previous="Previous",
    show_if_single_page=True,
)}
<div class="row">
    <div class="col-sm-12">
      <div class="hz_yt_bg fill-div">
      <div class="text-center" style="border-top: 1px solid #f4f4f4;border-bottom:1px solid #f4f4f4">
<small> Advertisement </small>
  </div>
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-format="fluid"
     data-ad-layout="image-side"
     data-ad-layout-key="-fg+5r+6l-ft+4e"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="6019459890"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
      </div>
    </div>
  </div>
  

    %else:

    <div class="hz_yt_bg">

    <p>Your search did not return any listings. Please try again</p>
         <div class="visible-xs visible-sm">
        <a href="#" id="show-advanced">Toggle Advanced Filter Options</a>
        <div id="advanced-search" style="display: none">
    <%include file="buddy:templates/listing/property/psearch.mako" />
            </div>
    </div>
    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<ins class="adsbygoogle"
     style="display:block"
     data-ad-format="fluid"
     data-ad-layout="image-side"
     data-ad-layout-key="-fg+5r+6l-ft+4e"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="6019459890"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
    </div>
%endif
</div>
</div>
</div><!--/.container -->
