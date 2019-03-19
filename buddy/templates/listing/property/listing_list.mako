<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>

<%block name="script_tags">
<script src="${request.static_url("buddy:static/sticky.js")}"></script>
  <script>
      $(function(){
  $("#sticker").sticky({topSpacing:0});
    });

    </script>

</%block>
<div class="container">
<section class="content-header">
    <div class="row">
        <div class="col-md-6" style="margin-top: -20px">
            <h1>${title}</h1>
        </div>
        <div class="col-md-6 col-md-6 hidden-xs hidden-sm">
            <%include file="breadcrumb.mako"/>
        </div>
    </div>

    </section>

    <%doc>
    <div class="row">
        <div class="col-md-12">


    <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- ForSalePage Top -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-2823597361043659"
     data-ad-slot="1515810128"
     data-ad-format="auto"></ins>
<script>

(adsbygoogle = window.adsbygoogle || []).push({});
</script>
</div>
        </div>
        </%doc>
    <section class="content">
<div class="row" id="listing-list">
    <div class="col-sm-4 col-sm-push-8">
    <%include file="buddy:templates/listing/property/psearch.mako" />
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
	<div class="col-sm-8 col-sm-pull-4" >

%if paginator:
<div class="row">
	%for item in paginator.items:

  %if loop.index==3 or loop.index==6:
    <div class="col-md-6">

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
     data-ad-slot="9242329153"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
      </div>
  </div>
  %endif
<div class="col-md-6">

${zdetails(item)}
</div>
	%endfor

</div>
        <p class="pagelist">
        ${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=False,
)}
</p>


    %else:
    <div class="hz_yt_bg">
    <p>We do not have any active listing here right now. <a href="${request.route_url('add_listings')}">Add one</a></p>

    </div>
%endif
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
    </section>
</div><!--/.container -->
