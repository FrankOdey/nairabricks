

<script>
    $(document).ready(function(){
        $(".rating").rating({'size':'xs'});
        $('#ratingForm').validate({
        rules:{
            rating:{min:2}
        }
        });
        $('#ratingForm').submit(function() {

        $(this).ajaxSubmit({
            success:location.reload()
        });

        // !!! Important !!!
        // always return false to prevent standard browser submit and page navigation
        return false;
    });

            });
</script>
<div class="modal fade" id="ratingModal" tabindex="-1" role="dialog" aria-labelledby="ratingModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="ratingModalLabel">Rate ${user.fullname}</h4>
      </div>
      <div class="modal-body">
        ${form.begin(url=request.route_url('user_rating',prefix=user.prefix),id="ratingForm", method="post", role="form")}
        <input type="hidden" name="csrf_token" value="${get_csrf_token()}">
        <div class="form-group">
        ${form.label('Overall rating', class_="control-label")}
        ${form.text('rating',class_="rating required")}
        </div>
        <div class="form-group">
        ${form.label('Review',class_="control-label")}
        ${form.textarea('review',rows="6", class_="form-control required")}
        </div>

         <div class="form-group">
         <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        ${form.submit('form_submitted',value="Submit", class_="btn btn-pink")}
        </div>
      </div>
        ${form.end()}
    </div>
  </div>
</div>