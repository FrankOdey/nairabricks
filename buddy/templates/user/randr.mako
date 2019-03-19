<%inherit file = "userbase.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>

<div class="row">
    <div class="col-sm-8">
    <div class="hz_yt_bg">
	<h3>${title}</h3>
%if paginator:
                     %for rating in paginator.items:
                     <div class="media"  id="media">

                                             %if rating.rater.photo:
                                             <a href="${request.route_url('profile', prefix=rating.rater.prefix)}" class="pull-left">
                                             <img src="${request.storage.url(rating.rater.photo)}" class="media-object img-responsive" width="40"></a>
                                             %else:
                                             <a href="${request.route_url('profile', prefix=rating.rater.prefix)}" class="pull-left">
                                             <img src="/static/male avater.png" class="media-object img-responsive" width="40"  ></a>
                                             %endif

                                              <div class="media-body">
                                          <ul class="list-inline"><li style="font-size: 8px"><input id="input-id" type="number" value="${rating.rating}"
                                                   class="rating" min=0 max=5 data-size="xs"
                                                       data-show-caption="false" data-show-clear="false"
                                                      data-readonly="true"> </li>
                            <li> ${rating.rating}</li></ul>
                                                     <p>${rating.review}</p>
                                               </div>
                                               </div>
                     %endfor
                     <div class="wrapper pull-right" style="padding:0px;">${paginator.pager(
                     '$link_previous ~3~ $link_next',
                     	link_attr={"class":"btn btn-sm btn-pink"},
                     	curpage_attr={"class":"btn btn-sm btn-default disabled"},
                     	symbol_next="Next",
                     	symbol_previous="Previous",
                     	show_if_single_page=True,
                     )}
                     </div>
                     %else:
                     <p class="text-muted">${user.fullname} have not been reviewed yet</p>
     %endif

	</div>
    </div>

    <div class="col-sm-4">
        ${h.featured_professionals(request)|n}
    </div>
</div>

