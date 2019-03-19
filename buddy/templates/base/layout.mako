<%inherit file="base.mako"/>
<div class="wrapper">
    <header class="main-header">
       <%include file="nav.mako"/>
    </header>

<div class="content-wrapper">

${self.flash_messages()}
${next.body()}

</div>
</div>

<%def name="flash_messages()">
		% if request.session.peek_flash():

		<% flash = request.session.pop_flash() %>
		% for message in flash:

<div class="alert alert-${message.split(';')[0]} alert-dismissable col-xs-12">
	 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>

				${message.split(";")[1]}

		</div>

		% endfor

	% endif
</%def>