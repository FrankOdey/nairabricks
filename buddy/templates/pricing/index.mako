<%inherit file="buddy:templates/base/layout.mako"/>
<div class="container-fluid">
<section class="content-header">
      <h1>
        Subscription Plans
      </h1>

    </section>
<section class="content" id="pricing">
                <div class="panel panel-danger">
                    <div class="panel-body text-center bg-info">
                        %if request.user:
                            %if request.user.active_subscription:

                            <p class="bg-primary"><strong>Current subscription: ${request.user.active_subscription[0].plan.name} Plan</strong></p>
                                %else:
                                 <h4><strong>Upgrade</strong> your account to list more than <strong>5 properties</strong></h4>
                                <p>Upgrading your account will also enable you to feature your listings and profile</p>
                       %endif
                            %else:
                            <h4><strong>Signup</strong> and <strong>Upgrade</strong> your account to list more than <strong>5 properties</strong></h4>
                                <p>Upgrading your account will also enable you to feature your listings and profile</p>
                        %endif

                    </div>
                </div>
                <div class="row">
                <div class="col-md-3">
                            <!-- PRICE ITEM -->
                    <div class="panel priced panel-grey">
                        <div class="panel-heading  text-center">
                        <h3>Free Plan</h3>
                        </div>
                        <div class="panel-body text-center">
                            <p class="lead" style="font-size:40px"><strong>${h.naira}0 / month</strong></p>
                        </div>
                        <ul class="list-group list-group-flush text-center">
                            <li class="list-group-item">5 Maximum Listings</li>
                            <li class="list-group-item"> 5 Maximum blog posts</li>
                            <li class="list-group-item"> 0 Premium Listings</li>
                            <li class="list-group-item"> 0 Premium blog posts</li>
                             <li class="list-group-item"> No Featured Profile</li>
                        </ul>
                        <div class="panel-footer">
                            <a class="btn btn-lg btn-block btn-success" href="#" disabled="disabled">FREE</a>
                        </div>
                    </div>
                    </div>
                    %for plan in plans:
                <div class="col-md-3">
                            <!-- PRICE ITEM -->
                    <div class="panel priced ${loop.cycle('panel-blue', 'panel-red')}">
                        <div class="panel-heading  text-center">
                        <h3>${plan.name} Plan</h3>
                        </div>
                        <div class="panel-body text-center">
                            <p class="lead" style="font-size:40px"><strong>${h.naira}${plan.price_per_month} / month</strong></p>
                        </div>
                        <ul class="list-group list-group-flush text-center">
                            <li class="list-group-item"> Unlimited Listings</li>
                            <li class="list-group-item"> Unlimited blog posts</li>
                            <li class="list-group-item"> ${plan.max_premium_listings} Premium Listings</li>
                            <li class="list-group-item"> ${plan.max_premium_blogposts} Premium blog posts</li>
                            %if plan.featured_profile:
                                <li class="list-group-item"><i class="glyphicon glyphicon-ok"></i> Featured Profile</li>
                                %else:
                                <li class="list-group-item">No Featured Profile</li>
                            %endif

                        </ul>
                        <div class="panel-footer">
                            <a class="btn btn-lg btn-block btn-danger" href="${request.route_url('subscribe_plan',name=plan.name, type="Upgrade")}">Pay Online</a>
                            <div class="text-center">
                                <small><a href="#cash_payment">Pay via Bank transfer or Cash</a></small></div>
                        </div>
                    </div>
                    </div>
                    %endfor


                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-success">
                            <div class="panel-body bg-danger text-center">
                                <h4><b>Have questions about our subscription plans? Contact Us.</b></h4>
                                <p><em>Whatsapp: +234 806 3975 610</em></p>
                                <p><em>Email: <a style="color:#e23c3c;text-decoration:underline;" href="mailto:info@nairabricks.com">info@nairabricks.com</a></em></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12" id="cash_payment">
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                <h4 class="panel-title">Cash Payment</h4>
                            </div>
                            <div class="panel-body bg-success text-center">
                                <h4><b>All bank transfers, cash and cheque payments should be made to:</b><br/>
                                    <hr/>
                                <b>Account name:</b> Smartbrands and Digital Solution<br/><br/>
                                <b>Account No:</b> 0022224065<br/><br/>
                                <b>Bank:</b> StanbicIBTC<br/><br/>
                                <b>Payment Description:</b> Here, write the plan and your Nairabricks account ID<br/>
                            </h4>
                                <h4 class="text-danger">Scan, take a picture or screenshot the deposit slip, cheque or transfer success page and mail it to
                                    <a style="color:#e23c3c;text-decoration:underline;" href="mailto:info@nairabricks.com">info@nairabricks.com</a></h4>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-body">
                        %if request.user:
                            <h4><b>Your accound ID is ${request.user.serial}</b></h4>
                        %endif

                           </div>
                        </div>
                    </div>
                </div>


</section>
    </div>