<%inherit file = "buddy:templates/base/layout.mako"/>
<%namespace file = "buddy:templates/search/index.mako" import="searchform"/>

<div class="container">
    <div class="row">
        <div class="col-md-12">
        	<div class="col-sm-12 ">
                ${searchform()}
<div class="hz_yt_bg">

%if paginator:
    <%
    table = h.distribute(paginator.items,4,'H')
    %>
    %for row in table:
<div class="row">
        %for user in row:

                %if user:

             <div class="col-sm-3 text-center fill-div" onclick="location.href='${request.route_url('profile',prefix=user.prefix)}'">
               %if user.photo:
<div class="circle-avatar" style="background-image:url(${request.storage.url(user.photo)});border:2px solid #fff;"></div>
    %else:
    <div class="circle-avatar" style="background-image:url('/static/default-picture.jpg');border:2px solid #fff;"></div>
%endif
<div class="profile-info" itemscope="" itemtype="http://schema.org/localbusiness">
<p><a class="profile-full-name" itemprop="name" href="${request.route_url('profile',prefix=user.prefix)}"></a>
    ${user.fullname}<br/>${user.company_name or ''}</p>
    </div>
           </div>
            %endif

        %endfor
</div>

    %endfor

    </div>
    ${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-sm btn-pink"},
	curpage_attr={"class":"btn btn-sm btn-default disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
%endif

        </div>
            </div>
    </div>
</div>