<%def name="delete_modal(question, link)">
<div class="modal fade" id="confirm-modal" tabindex="-1" role="dialog" aria-labelledby="cfLandingLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="cfLandingLabel">Confirm Delete</h4>
      </div>
      <div class="modal-body">
	  		<p class="text-center">${question}</p>
          <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <a id="delete" href="${link}" class="btn btn-danger">Delete</a>
      </div>
	</div>
	</div>
    </div>
    </div>
</%def>