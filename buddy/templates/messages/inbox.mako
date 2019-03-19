<%inherit file="buddy:templates/base/layout.mako"/>
<div class="container" style="background: #d0e9c6">
<div class="row">
    <div class="col-md-3 hidden-xs hidden-sm">
<%include file="buddy:templates/user/accountNav.mako"/>

        </div>
    <div class="col-md-6">

        <h2>Notification</h2>
        %if paginator:

        %for message in paginator.items:
            <div class="media">
                <a href="#" class="pull-left"><img src="/static/logo.png" style="width:40px;height:40px"/></a>
                <div class="media-body">
                    <div class="media-heading">
                        ${message.type} <span class="pull-right">${message.timestamp}</span>
                    </div>
                    <a href="${message.url}">${message.title}</a><br>
                    ${message.body}
                    <a href="${request.route_url('delete_message', id=message.id,user_id=user.id)}" class="btn btn-xs btn-danger pull-right">Delete</a>
                </div>

            </div>
        %endfor

        %endif

    </div>
    <div class="col-md-3 hidden-sm hidden-xs">

    </div>
    </div>
    </div>
