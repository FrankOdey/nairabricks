<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>

            %if listings:
	%for item in listings:
            <div class="row ">
                ${zdetails(item)}
            </div>
	%endfor
    <p class="text-center"><a href="${request.route_url('all_property_listing')}" class="btn btn-danger btn-sm">More properies &Gt;</a></p>
   %endif