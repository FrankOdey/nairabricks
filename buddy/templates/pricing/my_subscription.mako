<%inherit file = "buddy:templates/dash/base.mako"/>
<div class="container-fluid">
<section class="content-header">
      <h1>
        My Subscription
      </h1>
</section>
    <section class="content">
    <div class="row">
        <div class="col-md-8">
            <div class="callout callout-info">
                <h4>Current Subscription</h4>
                %if plan:
                    <span class="label label-danger">${plan.name} Plan</span>
                    %else:
                    <span class="label label-danger">Free Plan</span>
                    %endif
            </div>
                     <div class="box box-default">
                <div class="box-header">
                    <div class="box-title">Benefits</div>
                </div>
                <div class="box-body table-responsive no-padding">
                    <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>Service</th>
                                <th>Available</th>
                                <th>Used</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Max Standard Listing</td>
                                %if plan:
                                    <td>Unlimited</td>
                                    %else:
                                    <td>5</td>
                                %endif
                                    <td>${user.total_listings}</td>
                            </tr>
                            <tr><td>Max Blog Posts</td>
                                %if plan:
                                    <td>Unlimited</td>
                                    %else:
                                    <td>5</td>
                                %endif
                                <td>${user.total_blogs}</td>
                            </tr>
                            <tr>
                                <td>Max Premium Listing</td>
                                %if plan:
                                    <td>${plan.max_premium_listings}</td>
                                    %else:
                                    <td>0</td>
                                %endif
                                <td>${total_premium_listings}</td>
                            </tr>
                            <tr><td>Max Premium Blog Posts</td>
                                %if plan:
                                    <td>${plan.max_premium_blogposts}</td>
                                    %else:
                                    <td>0</td>
                                %endif
                                <td>${total_premium_blogs}</td>
                            </tr>
                            <tr><td>Featured Profile</td>
                                %if plan:
                                %if plan.featured_profile:
                                    <td>Yes</td>
                                    %else:
                                    <td>No</td>
                                %endif
                                    %else:
                                    <td>No</td>
                                     %endif

                            </tr>
                            </tbody>
                        </table>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-title">Upgrade Account</div>
                </div>
                <div class="panel-body">
                    <p>Your current subscription expires on:</p>
                            %if active_sub:
                             <p><span class="label label-danger">${active_sub.end_date.strftime("%b %d, %Y")}</span></p>
                                <p>Amount paid: <span class="label label-danger price">${int(active_sub.amount)}</span> </p>
                                %else:
                                <p><span class="label label-danger">when benefits are exhausted</span></p>
                            %endif
                    %if not plan:
                    <div class="callout callout-info">
                        <p>Upgrade your account now.</p>
                        <a href="${request.route_url('pricing')}" class="btn btn-danger btn-flat">Upgrade</a>
                    </div>
                        %endif
                    %if plan:
                        <p>Renewing your subscription before the end of the active subscription gives you an extra 2days</p>
                        <a href="${request.route_url('subscribe_plan', name=plan.name, type="Renew")}" class="btn btn-warning btn-flat">Renew Subscription</a>
                    %endif

                </div>
            </div>
        </div>
    </div>
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info">
                    <div class="box-header">
                        <div class="box-title">Subscriptions</div>
                    </div>
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Subscription Period</th>
                                <th>Payment Date</th>
                                <th>Reference</th>
                                <th>Plan</th>
                                <th>No of months</th>
                                <th>Price</th>
                                <th>Discount</th>
                                <th>Paid</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            %if subscriptions:
                            %for item in subscriptions:

                            <tr>
                                <td>
                                    ${item.start_date.strftime("%b %d, %Y")} - ${item.end_date.strftime("%b %d, %Y")}
                                </td>
                                <td>${item.start_date.strftime("%b %d, %Y")}</td>
                                <td>${item.reference}</td>
                                <td>${item.plan.name}</td>
                                <td>${item.no_of_months}</td>
                                <td>${item.plan.price_per_month*item.no_of_months}</td>
                                <td>${item.discount}</td>
                                 <td class="price">${int(item.amount)}</td>
                                <td>
                                    ${item.status}
                                </td>
                            </tr>
                            %endfor
                                %endif
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>