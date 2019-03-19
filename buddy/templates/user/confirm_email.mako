<%inherit file="buddy:templates/base/layout.mako"/>
<div class="container">
    <div class="content">
        <div class="row" style="margin-top:100px;margin-bottom:100px">
            <div class="col-md-6 col-md-offset-3">
            You have not confirmed your email address.
            Please <a href="${request.route_url('send_confirmation_email')}">click here</a> to confirm your email address.
        </div></div>

    </div>
</div>