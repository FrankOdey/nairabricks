<%inherit file="buddy:templates/dash/base.mako" />
%if paginator:
<div class="row">
<div class="col-md-12">
<p class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"button button-small button-primary"},
	curpage_attr={"class":"button button-small button-default uk-disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
</div>
</div>
<div class=''>
<table class="table table-striped table-condensed">
    <thead>
        <tr>
        <th>IP Address</th>
        <th>Fullname</th>
        <th>Email</th>
        <th>Date </th>
        <th>Event</th>
        </tr>
    </thead>
    <tbody>
%for item in paginator.items:
    <tr>
    <td valign="top">
    ${item.ip_addr}
    </td>
    <td valign="top">
    <a href="${request.route_url('profile', prefix=item.user.prefix)}">${item.user.fullname}</a>
    </td>
    <td valign="top">
    ${item.user.email}
    </td>
    <td valign="top">
    ${item.timestamp}
    </td>
    <td valign="top">
    ${item.event}
    </td>
    </tr>

%endfor
</tbody>
</table>
</div>
<div class="row">
<div class="col-md-12">
<p class="pull-right">${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"uk-button uk-button-small uk-button-primary"},
	curpage_attr={"class":"uk-button uk-button-small uk-btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
</p>
</div>
</div>
%endif