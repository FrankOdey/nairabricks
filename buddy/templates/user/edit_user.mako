<%inherit file = "buddy:templates/base/layout.mako"/>
<%block name="header_tags">
${parent.header_tags()}
   <!-- Include Font Awesome. -->
  ##<link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="/static/froala/css/froala_editor.min.css" rel="stylesheet" type="text/css">
  <link href="/static/froala/css/froala_style.min.css" rel="stylesheet" type="text/css">

    <!-- Include Editor Plugins style. -->
  <link rel="stylesheet" href="/static/froala/css/plugins/char_counter.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/code_view.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/colors.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/emoticons.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/file.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/fullscreen.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/image.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/image_manager.min.css">
 ## <link rel="stylesheet" href="/static/froala/css/plugins/line_breaker.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/table.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/video.min.css">
</%block>
<%block name="script_tags">

<script src="/static/froala/js/froala_editor.min.js"></script>
${parent.script_tags()}
    <!-- Include Plugins. -->
  <script type="text/javascript" src="/static/froala/js/plugins/align.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/char_counter.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/code_view.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/colors.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/emoticons.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/entities.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/file.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/font_family.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/font_size.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/fullscreen.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/image.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/image_manager.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/inline_style.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/line_breaker.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/link.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/lists.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_format.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_style.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/quote.min.js"></script>
  ##<script type="text/javascript" src="/static/froala/js/plugins/table.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/save.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/url.min.js"></script>
 ## <script type="text/javascript" src="/static/froala/js/plugins/video.min.js"></script>
  <script>
      $(function(){
          $('#editor').froalaEditor({
              key:"NcofbppaA-21vC-13dD2zuv==",
              pastePlain: true,
              heightMin: 200
              // Set the image upload URL.
          });

        $('#upload_profile_pix').validate();
        $('#upload_cover_pix').validate();
        $("#upload_company_pix").validate();
    });
    </script>
</%block>

<div class="container">
    <section class="content">
         <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
              <li class="active"><a href="#eandp" data-toggle="tab" aria-expanded="true">Change Password</a></li>
              <li class=""><a href="#pinfo" data-toggle="tab" aria-expanded="false">Edit Personal Info</a></li>
              <li class=""><a href="#about" data-toggle="tab" aria-expanded="false">Edit About</a></li>
                <li class=""><a href="#photo" data-toggle="tab" aria-expanded="false">Add Profile Pictures/logo</a></li>
            </ul>
            <div class="tab-content">
                <div id="feedback"></div>
              <div class="tab-pane active" id="eandp">
                <!-- Email and password-->
                <%include file="buddy:templates/user/eandp.mako"/>
                <!-- /.email and password -->
              </div>
              <!-- /.tab-pane -->
              <div class="tab-pane" id="pinfo">
                <!-- Personal Info -->
                  <%include file="buddy:templates/user/personal.mako"/>
                  <!-- /.end personal info -->
              </div>
              <!-- /.tab-pane -->

              <div class="tab-pane" id="about">
                <!-- about form -->
                  <%include file="buddy:templates/user/abtfrm.mako"/>
                  <!-- /.about form -->
              </div>
              <!-- /.tab-pane -->
                <div class="tab-pane" id="photo">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="box box-widget widget-user">
                                %if user.cover_photo:

                                <%
            u=request.storage.url(user.cover_photo)
            u=u.replace('\\','/')
          %>
                                    <!-- Add the bg color to the header using any of the bg-* classes -->
            <div class="widget-user-header bg-black" style="background: url('${request.storage.url(u)}') center center;">
                                    %else:
                                    <!-- Add the bg color to the header using any of the bg-* classes -->
            <div class="widget-user-header bg-black" style="background: url('/static/bg.jpg') center center;">
                                    %endif


            </div>
            <div class="widget-user-image">
              <img class="img-circle" src="${request.storage.url(user.photo)}" alt="User Avatar">
            </div>
            <div class="box-footer">
              <div class="row">
                <div class="col-sm-4 border-right">
                  %if user.photo:
            <p><a  data-toggle="modal" href="#MyModal">Change profile picture</a></p>
            %else:
	<p><a  data-toggle="modal" href="#MyModal">Upload photo</a></p>
            %endif
        ${upload_form()}

                </div>
                <!-- /.col -->
                <div class="col-sm-4 border-right">
                 %if user.company_logo:
            <p><a  data-toggle="modal" href="#MyCompany">Change Company Logo</a></p>

            %else:
	<p><a  data-toggle="modal" href="#MyCompany">Upload Company logo</a></p>

                %endif
                ${upload_company_form()}
                    %if user.company_logo:
                        <img style="width:250px" src="${request.storage.url(user.company_logo)}"/>
                    %endif

                </div>
                <!-- /.col -->
                <div class="col-sm-4">
                   %if user.cover_photo:
                    <p><a  data-toggle="modal" href="#MyCover">Change Cover Photo</a></p>

                %else:
                    <p><a  data-toggle="modal" href="#MyCover">Upload Cover Photo</a></p>
                %endif
                ${cover_upload_form()}
                </div>
                <!-- /.col -->
              </div>
              <!-- /.row -->
            </div>
          </div>
                        </div>
                    </div>


                </div>
            </div>
            <!-- /.tab-content -->
          </div>
          <!-- /.nav-tabs-custom -->
        </div>
        <!-- /.col -->
    </section>
</div>
<%def name="upload_form()">
<div class="modal fade" id="MyModal" tabindex="-1" role="dialog" aria-labelledby="MyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyModalLabel"><strong> Upload Profile Picture</strong></h4>
      </div>
      <div class="modal-body">

${form.begin(url=request.route_url('user_picture_upload', prefix=user.prefix),multipart=True,
method="post", class_="form-horizontal", id="upload_profile_pix",role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
 <div class="form-group">
     <div class="col-sm-offset-2 col-sm-6">
	${form.label("Upload picture", class_="control-label")}
          ${form.file(name="profile_pix",  class_="form-control required",accept="image/*")}
        </div>
</div>
 <div class="form-group">
     <div class="col-sm-offset-6 col-sm-3">
          <button type="submit" class="btn btn-success green" name="form_submitted">Upload</button>
         </div>
		</div>
        </form>

</div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>
</%def>

<%def name="upload_company_form()">
<div class="modal fade" id="MyCompany" tabindex="-1" role="dialog" aria-labelledby="MyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyModalLabel"><strong> Upload Company Logo</strong></h4>
      </div>
      <div class="modal-body">
${form.begin(url=request.route_url('company_pix_upload', prefix=user.prefix),multipart=True,
method="post", class_="form-horizontal",id="upload_company_pix",role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
 <div class="form-group">
     <div class="col-sm-offset-2 col-sm-6">
	${form.label("Upload picture", class_="control-label")}
          ${form.file(name="company_pix",  class_="form-control required",accept="image/*")}
        </div>
</div>
 <div class="form-group">
     <div class="col-sm-offset-6 col-sm-3">
          <button type="submit" class="btn btn-success green" name="form_submitted">Upload</button>
         </div>
		</div>
${form.end()}

</div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>
</%def>
<%def name="cover_upload_form()">
<div class="modal fade" id="MyCover" tabindex="-1" role="dialog" aria-labelledby="MyCoverLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="MyCoverLabel"><strong> Upload Cover photo</strong></h4>
      </div>
      <div class="modal-body">

${form.begin(url=request.route_url('cover_pix_upload', prefix=user.prefix),multipart=True,
method="post", class_="form-horizontal", id="upload_cover_pix",role="form")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
 <div class="form-group">
     <div class="col-sm-offset-2 col-sm-6">
	${form.label("Upload picture", class_="control-label")}
          ${form.file(name="cover_pix",  class_="form-control required",accept="image/*")}
        </div>
</div>
 <div class="form-group">
     <div class="col-sm-offset-6 col-sm-3">
          <button type="submit" class="btn btn-success green" name="form_submitted">Upload</button>
         </div>
		</div>
        </form>

</div>
      <div class="modal-footer">

      </div>
    </div>
  </div>
</div>
</%def>