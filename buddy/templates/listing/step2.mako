<%inherit file = "buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%
from webhelpers.containers import distribute
from webhelpers.html.tools import js_obfuscate
 %>
<%block name="header_tags">
    <link rel="stylesheet" href="${request.static_url('buddy:static/dashboard-asset/dropzone.min.css')}"/>
<style>
    .dropzone .dz-message .note {
    font-size: 0.8em;
    font-weight: 200;
    display: block;
    margin-top: 1.4rem;
}
   .dropzone.dz-clickable .dz-message, .dropzone.dz-clickable .dz-message * {
    cursor: pointer;
}
.dropzone .dz-message {
    font-weight: 400;
}
.dropzone .dz-message {
    text-align: center;
    margin: 2em 0;
}
.dropzone.dz-clickable * {
    cursor: default;
}
.dropzone, .dropzone * {
    box-sizing: border-box;
}
</style>
</%block>
<%block name="script_tags">
<script src="${request.static_url('buddy:static/dashboard-asset/dropzone.min.js')}"></script>
<script>
    Dropzone.options.myUpload = {
         acceptedFiles: '.jpg, .jpeg, .png',
        parallelUploads:2,
        paramName:"file",
        maxFilesize: 5,
        timeout:300000,
        uploadMultiple:true,
        dictDefaultMessage:"Drop files here or click to upload",
        // Prevents Dropzone from uploading dropped files immediately
        autoProcessQueue :false,
        init: function() {
            var submitButton = document.querySelector("#submit-all");
            myDropzone = this; // closure

            submitButton.addEventListener("click", function() {
                $("#submit-all").hide();
                $("#note").removeClass("hidden");
                myDropzone.processQueue(); // Tell Dropzone to process all queued files.
                });
            this.on("processing", function () {
                this.options.autoProcessQueue = true;
            });
                // You might want to show the submit button only when
                // files are dropped here:
            this.on("addedfile", function() {
            // Show submit button here and/or inform user to click it.

            });
            this.on("cancelled", function (file, xhr, formData) {
                alert("Network issue, please reload page")
            });
            this.on("totaluploadprogress", function(progress){
                $('.progress-bar').attr('aria-valuenow', progress+"%").css('width',progress+"%").html(progress+"%");
            });
            // CALLBACK ON COMPLETE UPLOADING EACH FILE
        this.on("complete", function (file) {
          // IF THERE ARE NO MORE FILES TO UPLOAD AND THE QUEUE IS EMPTY DO SOMETHING, ELSE GO ON WITH QUEUE PROCESS
          if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
            console.log("END ", this.getQueuedFiles().length);
          }
          else {
            // START QUEUE PROCESSING AGAIN
            Dropzone.forElement("#my-upload").processQueue();
          }
        });

        }
    }
</script>
</%block>
<section class="content-header">
      <h1>
        Add Pictures
      </h1>
      <ol class="breadcrumb">
        <li><a href="/"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">Add pictures</li>
      </ol>
    </section>
           <section class="content">
               <div class="row">
                   <div class="col-md-8">
               <div class="box box-success">
                   <div class="box-header with-border">
                       <h3 class="box-title">Upload pictures to property</h3>
                   </div>
                   <div class="box-body">
                       <div class="alert alert-warning">
                        <p><b>Important!</b> Do not upload random images from the internet.
                            If you don't have pictures of the property, you can skip uploading pictures now and do it later.</p>
                        <p>Uploading random pictures will lead to your account being flagged for violation
                            and you will be suspended from using our website</p>
                    </div>
                       <p class="text-danger">Minimum of 4 pictures makes your porperty standout</p>
           <br>
                       <%doc>
                       <form action="${request.route_url('listing_upload', listing_id=listing.id)}" class="dropzone needsclick dz-clickable" id="my-upload">
    <input type="hidden" name="csrf_token" value="${get_csrf_token()}"/>
  <div class="dz-message needsclick">
    Drop files here or click to upload.<br>
  </div>

</form>
</%doc>
                       <div class="progress">
  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
    <span class="sr-only"></span>
  </div>
</div>
                       <form action="${request.route_url('listing_upload', listing_id=listing.id)}" id="my-upload" class="dropzone" method="POST">
                           <input type="hidden" name="csrf_token" value="${get_csrf_token()}"/>
                        <div class="fallback">
        <h3>Your browser is not supported.</h3>
        <strong>
            <a href="https://browser-update.org/update.html" target="_blank">Click here for instructions on how to update it.</a>
        </strong>
        <p>You can still try to upload your pictures through this form: </p>
        <p>
            <input name="file" type="file" multiple />
            <input type="submit" name="submit" value="Upload" />
        </p>
     </div>
                       </form>
                       <div class="text-center with-border">
                       <button class="btn btn-flat btn-primary" id="submit-all" type="submit">Upload all</button>
                           <p class="text-muted hidden" id="note">If a file upload fails, it could most likely be because of network or timeout.
                               Add it back by clicking on the above area. It will upload automatically.</p>
                           </div>
    <br>
<div class="box box-default">
    <div class="box-body">
${up|n}
        <hr>
        ${form2.begin(method="post")}
            <input type="hidden" name="csrf_token" value="${get_csrf_token()}"/>
        <div class="panel panel-default" id="featuresetPanel">
    <div class="panel-heading text-center" role="tab">
      <h4 class="panel-title">
        <a role="button" id="featuresetToggle" data-toggle="collapse" href="#featureset" aria-expanded="false" aria-controls="featureset">
         Click to add Features of property <span class="glyphicon glyphicon-circle-arrow-down"></span>
        </a>
      </h4>
    </div>
    <div id="featureset" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
                    <fieldset>
                        %for feature in features:
                            <fieldset>
                                <legend>${feature.name}</legend>
                                <%
                                    features_ = h.distribute(feature.features,3,'V')
                                    %>
                                <div class="row">
                                %for row in features_:
                                    <div class="col-md-4">
                                        %for item in row:
                                            %if item:

                                            <div class="checkbox">
                                            <label>
                                    <input type="checkbox" name="${item.id}" > ${item.name}
                                            </label>
                                    </div>
                                            %endif
                                        %endfor


                                    </div>
                                %endfor
                                    </div>
                            </fieldset>
                        %endfor

                    </fieldset>
      </div>
    </div>
                     </div>
        <div class="row">
                        <div class="col-md-push-6 col-md-6">
                            <a href="${request.route_url('edit_listing',name=listing.name)}" class="btn bg-black pull-right" style="border-radius:0">Edit property details</a>
                            <button type="submit" name="save_features" class="btn bg-purple pull-right" style="border-radius:0"> Save Property </button>
                        </div>
                    </div>
        ${form2.end()}
        </div>
    </div>
                   </div>
               </div>
                   </div>
                <div class="col-md-4">
                    <div class="box box-default">
                        <div class="box-header with-border">
                            <h1 class="box-title">Property Details</h1>
                        </div>
                        <div class="box-body">
                            <p><b>Title</b><br>${listing.title}</p>
                            <p><b>Category</b><br>${listing.category.name} ${listing.listing_type}</p>
                            <p><b>Address</b><br>${listing.address}
                            %if listing.show_address:
                                <small><i>You selected to show this address</i></small>
                                %else:
                                <small><i>This address will not be shown</i></small>
                            %endif
                            </p>
                            <p class="price"><b>Price</b> <br>${listing.price}</p>
                            %if listing.price_available:
                                <small><i>You selected to show this price</i></small>
                                %else:
                                <small><i>This price will not be shown</i></small>
                            %endif

                            <p><b>Property ID</b><br>${listing.serial}</p>
                            <p><b>Approval Stage</b><br>
                            %if listing.approved:
                                Approved
                                %elif listing.declined:
                                Declined
                                %else:
                                Under Review
                            %endif
                            </p>

                        </div>
                    </div>
                </div>
            </div>
                </section>

