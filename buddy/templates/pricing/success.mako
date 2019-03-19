<%inherit file="buddy:templates/base/layout.mako"/>
<div class="container-fluid">
<div class="row" style="margin:5%">
    <div class="col-md-offset-2 col-md-8 text-center">
        <div class="panel panel-success" >
            <div class="panel-heading">
                <h4 class="panel-title">Transaction Successful</h4>
            </div>
            <div class="panel-body">
                <p>Your payment for plan ${sub.plan.name} was successful</p>
                <p style="font-size:20px">Thank you</p>
                <a href="${request.route_url('my_subscription')}" class="btn btn-flat btn-pink">View subscription</a>
            </div>
        </div>

    </div>
</div>
    </div>