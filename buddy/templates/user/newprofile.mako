<%inherit file = "buddy:templates/base/base.mako"/>
<%namespace file="buddy:templates/listing/property/all.mako" import ="details"/>
<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>
<%block name="header_tags">
${parent.header_tags()}
<style>
        li div,.overall div{
            display:inline;
        }
    </style>
</%block>
<%block name="script_tags">
    ${parent.script_tags()}
    <script type="text/javascript" src="${request.static_url('buddy:static/uikit-2.20.3/js/components/lightbox.min.js')}"></script>
</%block>
<div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <div style="background-image: url(${request.storage.url(user.photo)});min-height:300px; margin-top:-78px">

                        </div>
                        </div>
                    <div class="col-lg-4">
                        </div>
               </div>
    </div>