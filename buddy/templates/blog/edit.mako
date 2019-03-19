<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%block name="header_tags">
${parent.header_tags()}
   <!-- Include Font Awesome. -->

	<link href="/static/froala/css/froala_editor.min.css" rel="stylesheet" type="text/css">
  <link href="/static/froala/css/froala_style.min.css" rel="stylesheet" type="text/css">

    <!-- Include Editor Plugins style. -->
  <link rel="stylesheet" href="/static/froala/css/plugins/char_counter.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/code_view.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/colors.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/emoticons.min.css">

  <link rel="stylesheet" href="/static/froala/css/plugins/fullscreen.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/image.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/image_manager.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/line_breaker.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/table.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/video.min.css">
</%block>
<%block name="script_tags">


${parent.script_tags()}
  <script src="/static/froala/js/froala_editor.min.js"></script>
    <!-- Include Code Mirror. -->
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.3.0/codemirror.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.3.0/mode/xml/xml.min.js"></script>

    <!-- Include Plugins. -->
  <!-- Include Plugins. -->
  <script type="text/javascript" src="/static/froala/js/plugins/align.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/char_counter.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/code_beautifier.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/code_view.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/colors.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/emoticons.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/entities.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/file.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/font_family.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/font_size.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/fullscreen.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/image.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/image_manager.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/inline_style.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/line_breaker.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/link.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/lists.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_format.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_style.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/quick_insert.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/quote.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/table.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/save.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/url.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/video.min.js"></script>
  <script>
      $(function(){
          $('#editor').froalaEditor({
              toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', '-', 'insertLink', 'insertImage', 'insertVideo', 'insertTable', '|', 'quote', 'insertHR', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html'],
              key:"NcofbppaA-21vC-13dD2zuv==",
              pastePlain: true,
              heightMin: 300,
              // Set the image upload URL.
           imageUploadURL:"${request.route_url('image_upload')}",
           imageUploadParams:{"id":"editor","csrf_token":"${request.session.get_csrf_token()}"},
           imageManagerLoadURL:"${request.route_url('image_browse')}"
          })
          .on('froalaEditor.image.removed', function (e, editor, $img) {
        $.ajax({
          // Request method.
          method: "POST",

          // Request URL.
          url: "${request.route_url('image_delete')}",

          // Request params.
          data: {
            src: $img.attr('src'),
              "csrf_token":"${request.session.get_csrf_token()}"
          }
        })
        .done (function (data) {
          alert ('image deleted');
        })
        .fail (function () {
          alert ('failed to delete image in server');
        })
      });
	$('#bform').validate({
messages: {
title:{required:'Please ask your question before submitting'},
categories:{required:'Please select a category for your question'},
editor:{required:'Please write something'}
}
});
$('#category_id').multiselect({
    enableFiltering: true,
    maxHeight: 300
});

});

</script>
</%block>
<div class="container-fluid">
    <section class="content">
<div class="row">
<div class="col-md-8">
	<div class="box box-info">
	<div class="box-header">
<h4 class="box-title">
	Edit ${blog.title}
    </h4>
    </div>
        <div class="box-body">
${self.add_blog()}
        </div>
    </div>
</div>
	<div class="col-md-4">
    <div class="box box-info">
	<div class="box-header">
<h4 class="box-title">
	Be A Good Neighbor
    </h4>
    </div>
        <div class="box-body">
    Nairabricks Advice depends on each member
    to keep it a safe, fun, and positive place.
     If you see abuse, flag it.
    </div>
	</div>
	</div>
</div>
        </section>
</div><!-- /.ends container -->

<%def name="add_blog()">
${form.begin(url=action_url,id="bform", method="post",class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		${form.label("Title of blog post", class_="control-label")}<span class="req">*</span>
		${form.text('title', class_="form-control required",id="title")}
		${validate_errors("title")}
</div>
	
</div>
    <div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
${form.label("Categorize Your blog post")}<span class="req">*</span>
${form.select("category_id", multiple="True",selected_value=[x.id for x in blog.categories],
	options=categories,class_="form-control required")}
	${validate_errors("category_id")}
</div>
</div>
	<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		${form.label("Body")}<span class="req">*</span>
		${form.textarea('body' ,rows="10",id="editor", class_="ckeditor form-control required")}
		${validate_errors('body')}
		</div>
	</div>
    <%doc>
<div class="form-group">
	<div class="col-md-6">
${form.label("State")}<span class="text-muted">(optional)</span>
${form.select("state_id",prompt="Choose State",options=states,class_="form-control")}
</div>
</%doc>
	<div class="form-group">
<div class=" col-xs-12 col-sm-12 col-md-12 col-lg-12">

<button type="submit" name="form_submitted" class="btn btn-pink btn-flat pull-right">Publish</button>
    %if not blog.status:
<button type="submit" name="draft" class="btn btn-warning btn-flat pull-left">Save as Draft</button>
%endif
</div>
</div>
${form.end()}
 
</%def>