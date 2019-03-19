<%inherit file="buddy:templates/base/layout.mako"/>
	<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>
<%block name="header_tags">
${parent.header_tags()}
   <!-- Include Font Awesome. -->
  <link href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="/static/froala/css/froala_editor.min.css" rel="stylesheet" type="text/css">
  <link href="/static/froala/css/froala_style.min.css" rel="stylesheet" type="text/css">

    <!-- Include Editor Plugins style. -->
  <link rel="stylesheet" href="/static/froala/css/plugins/char_counter.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/code_view.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/colors.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/emoticons.min.css">
  ##<link rel="stylesheet" href="/static/froala/css/plugins/file.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/fullscreen.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/image.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/image_manager.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/line_breaker.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/table.min.css">
  <link rel="stylesheet" href="/static/froala/css/plugins/video.min.css">
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
  <script type="text/javascript" src="/static/froala/js/plugins/fullscreen.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/image.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/image_manager.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/inline_style.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/line_breaker.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/link.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/lists.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_format.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/paragraph_style.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/quote.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/table.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/save.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/url.min.js"></script>
  <script type="text/javascript" src="/static/froala/js/plugins/video.min.js"></script>
  <script>
      $(function(){
          $('#editor').froalaEditor({
              toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', '-', 'insertLink', 'insertImage', 'insertVideo', 'insertFile', 'insertTable', '|', 'quote', 'insertHR', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html'],
              key:"NcofbppaA-21vC-13dD2zuv==",
              pastePlain: true,
              heightMin: 300,
              // Set the image upload URL.
           imageUploadURL:"${request.route_url('image_upload')}",
           imageUploadParams:{"id":"editor","csrf_token":"${request.session.get_csrf_token()}"}
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

        })
        .fail (function () {

        })
      });
	$('#qform').validate({
messages: {
title:{required:'Please ask your question before submitting'},
category_id:{required:'Please select a category for your question'}
}
});

$('#category_id').multiselect({
      maxHeight: 200,
      enableFiltering: true
    });
});
</script>
</%block>

<div class="container" id="wrapper">
<div class="row">
<div class="col-md-3 uk-hidden-small">
    <div class="wrapper">
<%include  file= "buddy:templates/user/accountNav.mako"/>
        </div>
</div>
	<div class="col-md-6">
<div class="blog-wrapper">

<div class="page-header">
<h3><strong>${title}</strong></h3>
</div>
${self.add_q()}
	</div>
</div>
	<div class="col-md-3">
	<div class="wrapper">
	<div class="title">
	<h4><strong>Be A Good Neighbor</strong></h4>
	</div>
	Nairabricks Advice depends on each member to keep it a safe, fun, and positive place. If you see abuse, flag it.
	</div>
	</div>
</div>
</div><!-- /.ends container -->

<%def name="add_q()">
${form.begin(method="post", id="qform", class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		${form.label("What is your question?", class_="control-label")}<span class="req" style="color:#9f0e8e">*</span>
		${form.text('title', class_="form-control required")}
		${validate_errors("title")}
</div>

</div>
	<div class="form-group">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		${form.label("Add details")}<span class="text-muted">(optional)</span>
		${form.textarea('body' ,rows="6", id="editor", class_="form-control")}
		${validate_errors('body')}
		</div>
	</div>
<div class="form-group">
<div class="col-md-12">
${form.label("Categorize Your Question")}<span class="req">*</span>
    ${form.select('category_id',options=sorted(categories,key=lambda x:x[1]),
    selected_value=[x.id for x in question.categories],multiple="True", class_='form-control required')}
	${validate_errors("category_id")}
</div>
</div>
<div class="form-group">
	<div class="col-md-6">
${form.label("State")}<span class="text-muted">(optional)</span>
${form.select("state_id",prompt="Choose State",options=states,class_="form-control")}
</div>
	<div class="col-md-6">
 ${form.label("city")}<span class="text-muted">(optional)</span>
${form.text('city',class_="form-control")}
</div>
</div>
<div class="form-group">
<div class="col-md-12">
	${form.checkbox('anonymous',class_="checkbox-inline", label=" Post as anonymous user")}
</div>
</div>
	<div class="form-group">
<div class="col-md-6">
<button type="reset" onclick="location.href='${request.route_url('question_list')}'" name="cancel" class="btn btn-default">Cancel</button>
</div>
<div class="col-md-6">
<button type="submit" name="form_submitted" class="btn btn-pink pull-right">Submit</button>
</div>
</div>
${form.end()}

</%def>