%if len(listing.property_extra.features)>0:
<div id="feature-listing">

 <div class="h4"><b>Features</b></div>
<p class=" req ">In-House Amenities:</p>
${self.get_features('internal features')}

<p class="req ">External Amenities:</p>
${self.get_features('external features')}

<p class="req ">Eco Features:</p>
${self.get_features('eco features')}

<p class="req ">Other Amenities:</p>
${self.get_features('other features')}
</div>

<%def name="get_features(name)">

		<ul class="list-inline">
	%for feature in listing.property_extra.features:
		%if feature.feature_type.name.lower()==name:
			<li>${feature.name}</li>
		%endif
	%endfor
			</ul>

</%def>
%endif
