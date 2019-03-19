<%inherit file = "userbase.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>
<div class="row">
    <div class="col-sm-8">
        <div class="hz_yt_bg">
        <h4><i class="fa fa-heart"></i> Favourite properties</h4>
        %if paginator:
        %for item in paginator.items:
            ${details(item)}
        %endfor
            <div class="text-center">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</div>
            %else:
            <p>You have no saved properties.</p>
        %endif
    </div>
        </div>
    <div class="col-sm-4">
        ${h.featured_professionals(request)|n}
    </div>
</div>
