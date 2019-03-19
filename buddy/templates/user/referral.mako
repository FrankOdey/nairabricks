<%inherit file="buddy:templates/dash/base.mako"/>
<section class="content-header">
      <h1>
        Dashboard
          <small>My referrals</small>
      </h1>
      <ol class="breadcrumb">
          <li><a href="/"><i class="fa fa-home"></i> Home</a></li>
        <li><a href="${request.route_url('account')}"><i class="fa fa-dashboard"></i> Dashboard</a></li>
          <li><a href="#"><i class="fa fa-dashboard"></i> Referrals</a></li>
      </ol>
    </section>
<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header">
                   <p> Referral link:<code>${reflink}</code></p>
                    <p>Amount Earned: <code class="price">${user.balance}</code> </p>
                </div>
                <div class="box-body">
                    <div class="callout callout-danger">
                        <p>Earn a <span class="label label-info"> silver</span> subscription when you refer someone to nairabricks</p>
                        <h4>Details</h4>
                        <p>The first of your referrals to verify their profile earns you a silver subscription.
                        <span class="bg-black"> Any referral that post a property, earns you 1000 naira per property posted.
                            This money is usable in this platform. You can use it to pay for banner ads on our website</span></p>

                    </div>
                    %if paginator:
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                <th>#</th>
                                    <th>Name</th>
                                </tr>
                                </thead>
                                <tbody>
                                %for i, item in enumerate(paginator.items) :
                                    <tr>
                                        <td>${i+1}</td>
                                        <td><a href="${request.route_url('profile', prefix=item.prefix)}">${item.fullname}</a></td>
                                    </tr>
                                %endfor
                                <tr></tr>
                                </tbody>
                            </table>
                            ${paginator.pager(
'$link_previous ~3~ $link_next',
	link_attr={"class":"btn btn-pink btn-sm btn-flat"},
	curpage_attr={"class":"btn btn-default btn-sm btn-flat disabled"},
	symbol_next="Next",
	symbol_previous="Previous",
	show_if_single_page=True,
)}
                        </div>
                    %endif
                </div>
            </div>
        </div>
    </div>
</section>