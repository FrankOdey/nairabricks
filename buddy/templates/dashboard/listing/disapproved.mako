<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>
<div class="container">
      <div class="h4"><b>Unapproved Listings</b></div>
                               <hr>
                           %if paginator :

                           %for item in paginator.items:
                   <div class="row">

                   ${details(item)}
                   </div>

                   	%endfor
                   	<div class="pull-right">${paginator.pager(
                    '$link_previous ~3~ $link_next',
                    	link_attr={"class":"btn btn-sm btn-pink"},
                    	curpage_attr={"class":"btn btn-sm btn-default disabled"},
                    	symbol_next="Next",
                    	symbol_previous="Previous",
                    	show_if_single_page=True,
                    )}
                    </div>
                           %endif
</div>