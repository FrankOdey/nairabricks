
%if locality.pictures:
<figure class="uk-overlay">
<div id="slider1_container" style="position: relative; top: 0px; left: 0px; width: 800px;
        height: 456px; background: #191919; overflow: hidden;">
        <!-- Loading Screen -->
                <div u="loading" style="position: absolute; top: 0px; left: 0px;">
                    <div style="filter: alpha(opacity=70); opacity:0.7; position: absolute; display: block;
                        background-color: #000000; top: 0px; left: 0px;width: 100%;height:100%;">
                    </div>
                    <div style="position: absolute; display: block; background: url(/static/jssor/img/loading.gif) no-repeat center center;
                        top: 0px; left: 0px;width: 100%;height:100%;">
                    </div>
                </div>
<div u="slides" style="cursor: move; position: absolute; left: 0px; top: 0px; width: 800px; height: 356px; overflow: hidden;">
%for image in locality.pictures:
<div>
<a  href="${request.storage.url(image.filename)}" data-uk-lightbox="{group:'group1'}"><img u="image" src="${request.storage.url(image.filename)}"></a>
<img u="thumb" src="${request.storage.url(image.filename)}">
</div>
%endfor
</div>
<!-- Arrow Left -->
        <span u="arrowleft" class="jssora05l" style="top: 158px; left: 8px;">
        </span>
        <!-- Arrow Right -->
        <span u="arrowright" class="jssora05r" style="top: 158px; right: 8px">
        </span>
<!-- thumbnail navigator container -->
        <div u="thumbnavigator" class="jssort01" style="left: 0px; bottom: 0px;">
            <!-- Thumbnail Item Skin Begin -->
            <div u="slides" style="cursor: default;">
                <div u="prototype" class="p">
                    <div class=w><div u="thumbnailtemplate" class="t"></div></div>
                    <div class=c></div>
                </div>
            </div>
            <!-- Thumbnail Item Skin End -->
        </div>
        <!--#endregion Thumbnail Navigator Skin End -->
  </div>
  <figcaption class="uk-overlay-panel uk-overlay-top uk-overlay-background"><h4>${len(files)} Photos. <small>Click Image to view larger and nicer</small></h4></figcaption>
                  </figure>

%else:
             <figure class="uk-overlay">
                <img src="http://placehold.it/800x356/357ebd/fff?text=No+Pictures">
                <figcaption class="uk-overlay-panel uk-overlay-bottom uk-overlay-background"><h4>${locality.city_name}(${locality.state.name})</h4></figcaption>
                </figure>
%endif
                <div style="display:inline" class="text-center"><input type="number" class="rating" min=0 max=5 data-size="xs" value="${locality.overall_avg}"
                                                                   data-show-caption="false" data-show-clear="false" data-readonly="true">
                                                                                    </div>
                <p class="text-center" style="border-bottom: 1px dashed #ccc">
                                <a href="${request.route_url('view_local', name=locality.name)}">City Overview</a>|
                                <a href="${request.route_url('rate_local',name=locality.city_name)}">Rate this city</a>|
                                ##<a href="${request.route_url('add_city_pictures',name=locality.name)}">Add Pictures</a></p>
