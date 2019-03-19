<%inherit file="buddy:templates/base/layout.mako"/>

<%def name="searchform()">
    <div class="hz_yt_bg">
 <form class="form-inline" action="${request.route_url('find_pros')}" method="get" id="proform">
    <div class="form-group has-success">
        <label class="control-label" for="ProType">Pro type</label>
       ${form.select('type',options=h.get_user_types(),selected_value=protype,prompt="Professional type",class_="form-control")}
        </div>
    <div class="form-group has-success has-feedback">
        <label class="control-label" for="location">Location</label>
        ${form.text('cities_auto',value=location,placeholder='Enter State, city or area',class_="form-control",size="20")}
    </div>
    <div class="form-group has-success has-feedback">
        <label class="control-label" for="name">Name</label>
        <input name="name" id="name" type="text" value="${name}" class="form-control" placeholder="Name">
        </div>
     <div class="form-group">
       <button class="btn btn-site" id="prosearch">Search</button>
    </div>
</form>
    </div>
</%def>

<div class="container">
    <div class="row">
        	<div class="col-sm-12 ">
                ${searchform()}


%if paginator:
    <%
    table = h.distribute(paginator.items,4,'H')
    %>
    %for row in table:
<div class="row">
        %for user in row:

                %if user:

             <div class="col-sm-3 col-xs-6 text-center ">
                 <div class="hz_yt_bg fill-div" onclick="location.href='${request.route_url('profile',prefix=user.prefix)}'">
               %if user.photo:
<div class="circle-avatar img-responsive" style="background-image:url(${request.storage.url(user.photo)});border:2px solid #fff;"></div>
    %else:
    <div class="circle-avatar img-responsive" style="background-image:url('/static/male avater.png');border:2px solid #fff;"></div>
%endif
<div class="profile-info" itemscope="" itemtype="http://schema.org/localbusiness">
<p><a class="profile-full-name" itemprop="name" href="${request.route_url('profile',prefix=user.prefix)}"></a>
    ${user.fullname}
%if user.is_verified:
        <img src="/static/verified.png" width="20" data-toggle="tooltip" data-placement="bottom"
             title="Verified Professional" />
    %endif
</p>

    <p>
        %if user.user_type and user.company_name:
        <span class="label label-primary">${user.user_type.name}</span> with ${user.company_name}
        %elif user.user_type:
            <span class="label label-primary">${user.user_type.name}</span>
         %elif user.company_name:
            ${user.company_name}
        %endif
         </p>
    </div>
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

