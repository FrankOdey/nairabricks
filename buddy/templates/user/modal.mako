<%def name ="modal_call(modal_body, modal_title)">

    <div class="modal fade" id="MyModal" tabindex="-1" role="dialog" aria-labelledby="MyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyModalLabel"><strong>${modal_title}</strong></h4>
      </div>
      <div class="modal-body">
        ${modal_body}

      </div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>

</%def>