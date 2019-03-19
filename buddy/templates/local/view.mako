<%inherit file = "buddy:templates/base/base.mako"/>
<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>

<%block name="header_tags">
    ${parent.header_tags()}
    <style>
        li div,#overall div{
            display:inline;
        }
    </style>
</%block>

<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <div class="blog-wrapper">
                   <h1 class="text-center">${locality.city_name} in ${locality.state.name}</h1>
                    <%include file="citynav.mako"/>

                    <%include file="ratingview.mako"/>


</div>
        </div>
    </div>
</div>