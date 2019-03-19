<%inherit file="buddy:templates/base/layout.mako"/>


<div class="container">
<div class="row">
    <div class="col-md-4 col-md-offset-4">


<div class="text-center">
<div class="h4">Subscribe to ${plan.name} plan
%if type:
    <span class="label label-danger"> ${type}</span>
%endif
</div>
</div>



 <div class="row">
        <div class="col-md-12">
            <div class="box box-success">
                <div class="box-body">
           ${form.begin(url=request.route_url('subscribe_plan', name=plan.name,type=type), method="post")}
            <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
               <div class="form-group">
                   <label >Choose Duration</label>
                   %if type=="Renew":
                       <p style="color: #dd4b39;">When you renew your subscription before expiration, you get 2 more days free</p>
                   %endif

                   <div class="help-block">6 months or more is 5% discount, 12months is 10% discount</div>
                   <select name="duration" class="form-control" id="duration">
                    <option value="1">1 month</option>
                    <option value="2">2 month</option>
                    <option value="3">3 month</option>
                    <option value="4">4 month</option>
                    <option value="5">5 month</option>
                       <option value="6">6 month</option>
                       <option value="7">7 month</option>
                       <option value="8">8 month</option>
                       <option value="9">9 month</option>
                       <option value="10">10 month</option>
                       <option value="11">11 month</option>
                       <option value="12">12 month</option>
                   </select>
               </div>
            <ul class="nav nav-pills nav-stacked">
                <li class="active"><a><span class="badge pull-right" id="amount">${h.naira} ${plan.price_per_month}</span> Plan Amount</a>
                </li>
                <li class="active"><a><span class="badge pull-right">${h.naira} 0</span> Transaction Fee</a>
                </li>
                <li class="active"><a><span class="badge pull-right" id="discount"> - </span> Discount</a>
                </li>
                <li class="active"><a><span class="badge pull-right" id="finalPay">${h.naira} ${plan.price_per_month}</span> Final Payment</a>
                </li>
            </ul>
            <br/>
            <button type="submit" name="submit" class="btn btn-success btn-lg btn-block" role="button">Pay</button>
            ${form.end()}
                     </div>
            </div>
        </div>
    </div>

</div>

</div>
</div>

<%block name="script_tags">

<script>
$('#duration').on('change', function(){
    var value = parseInt($(this).val());
    var discount = "-";
    var total_amount =value * ${plan.price_per_month};
    var final_payment = total_amount;
    if (value===12){
        final_payment = total_amount-(total_amount*0.1);
        discount = "10%";
    }
    else if (value >= 6){
        final_payment = total_amount-(total_amount*0.05);
        discount = "5%";
    }

    $('#amount').html("${h.naira} "+total_amount.toString()+".0");
    $('#discount').html(discount)
    $('#finalPay').html("${h.naira} "+final_payment.toString()+".0");
});
</script>
</%block>