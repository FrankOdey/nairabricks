
<%doc>
	checks validate errors, if any validate errors, adds message as span
</%doc> 
<%def name="validate_errors(field)">
	% for message in form.errors_for(field):
		% if (message is not None):
			<span class="text-danger">${message}</span>	
		% endif
	% endfor
</%def>


