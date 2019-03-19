<div class="panel panel-default">
    <div class="panel-heading">Featured Professionals
        </div>
%if users:
            <div class="row">
                <div class="col-sm-12">
            %for user in users:
                <div class="hz_yt_bg fill-div" style="cursor:pointer" onclick="location.href='${request.route_url('profile',prefix=user.prefix)}'">
                <div class="row">
            <div class="col-xs-4">
                <div class="circle-avatar" style="background-image:url(${request.storage.url(user.photo)});border:2px solid #fff;"></div>
            </div>
                <div class="col-xs-8" style="font-weight: bold">
                    <p>${user.fullname.title()}
                    %if user.is_verified:
        <img src="/static/verified.png" width="20" alt="verified professional image" data-toggle="tooltip" data-placement="bottom"
             title="Verified Professional" />
    %endif
                    </p>
                    <p>${user.mobile or user.phone or ''}</p>
                    %if user.user_type:
                        <span class="label label-primary">${user.user_type.name}</span>
                    %endif
                </div>
               </div>
                </div>
            %endfor

                </div>
                </div>

</div>
    %endif