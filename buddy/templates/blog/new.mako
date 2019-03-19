<%inherit file="buddy:templates/base/layout.mako"/>
##	<%namespace file="buddy:templates/base/uiHelpers.mako" import="validate_errors"/>

<%block name="header_tags">

${parent.header_tags()}

    <!-- end deform tags -->
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
     <script src="/static/deform.js"></script>
    <script src="/static/deform_bootstrap.js"></script>
</%block>
<%block name="script_tags">

${parent.script_tags()}

<script type="text/javascript">
   deform.load()
</script>
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
          $('#deformField4').froalaEditor({
              toolbarButtons: ['fullscreen', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', '|', 'color', 'emoticons', 'inlineStyle', 'paragraphStyle', '|', 'paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', '-', 'insertLink', 'insertImage', 'insertVideo', 'insertFile', 'insertTable', '|', 'quote', 'insertHR', 'undo', 'redo', 'clearFormatting', 'selectAll', 'html'],
              key:"NcofbppaA-21vC-13dD2zuv==",
              pastePlain: true,
              heightMin: 200,
              // Set the image upload URL.
           imageUploadURL:"${request.route_url('image_upload')}",
           imageUploadParams:{"id":"editor","csrf_token":"${request.session.get_csrf_token()}"},
           imageManagerLoadURL:"${request.route_url('image_browse')}",
           imageManagerLoadParams: {"csrf_token":"${request.session.get_csrf_token()}"},
           imageManagerDeleteURL:"${request.route_url('image_manager_delete')}",
              imageManagerDeleteParams: {"csrf_token":"${request.session.get_csrf_token()}"}
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

        });
});
    var bform = $("#deform");
	bform.validate({
    rules: {
           title:"required",
            category_id:"required",
            body:"required"
}
});


$('#deformField3').multiselect({
      maxHeight: 200,
      enableFiltering: true
    });
});

</script>
</%block>

<div class="container-fluid">
    <ul class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" ><span itemprop="name">Add new blog post</span></a>
        <meta itemprop="position" content="2" /></li>

    </ul>
    </div>
<div class="container">
<div class="row">
<div class="col-md-4 col-md-push-8">
    <div class="hz_yt_bg">
     %if drafts:
            <h4 style="color:red">List of blogs currently in draft mode</h4>
                <ol>
            %for draft in drafts:
                <li>${draft.title}</li>
            %endfor
        %endif
                </ol>
        </div>
</div>
	<div class="col-md-8 col-md-pull-4">
<div class="hz_yt_bg">

${form|n}
</div>
</div>

    </div>


</div><!-- /.ends container -->
