<%inherit file = "buddy:templates/base/base.mako"/>
<%
from webhelpers.containers import distribute
import random
%>
<%block name="header_tags">
    ${parent.header_tags()}
    <style>
        li p{
            display:inline;
            font-size:7px;
        }
    </style>
    <link href="${request.static_url('buddy:static/uikit-2.20.3/css/components/accordion.almost-flat.min.css')}" media="all" rel="stylesheet"  type="text/css">
 </%block>
 <%block name="script_tags">
 ${parent.script_tags()}
 <script src="${request.static_url('buddy:static/uikit-2.20.3/js/components/accordion.min.js')}"></script>
 </%block>
<div class="container">
<div class="row" >
	<div class="col-xs-12 col-sm-12">
<div class="wrapper">
    <div class="uk-h2 title">Select state to view cities
    </div>
   <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
%if states:

    %for state in states:

    <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="${state.name}1">
      <h4 class="panel-title text-center">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#${state.name}" aria-expanded="true" aria-controls="collapseOne">
          ${state.name}
        </a>
      </h4>
    </div>

%if state.local:

<div id="${state.name}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="${state.name}1">
      <div class="panel-body">
    <%
        p=distribute(state.local,4,'V')
        %>

		%for row in p:

            <div class="uk-grid uk-grid-divider" data-uk-margin>

			%for item in row:
                <div class="uk-width-medium-1-4 uk-text-center">
			%if item:

            %if item.pictures:
                <img src="${request.storage.url(item.pictures[0].filename)}" class="listing-img">
                    %else:
             <figure class="uk-overlay">

                           <img  class="listing-img" src="${request.static_url('buddy:static/nopics.jpg')}"  alt="">

                <figcaption class="uk-overlay-panel uk-overlay-bottom uk-overlay-background"><h4>${item.city_name}(${item.state.name})</h4></figcaption>
                </figure>
              %endif
                <li><p><input type="number" class="rating" min=0 max=5 data-size="xs" value="${item.overall_avg}"
                                                                   data-show-caption="false" data-show-clear="false" data-readonly="true">${item.overall_avg}
                                                                                    </p></li>
                <p style="border-bottom: 1px dashed #ccc">
                                <a href="${request.route_url('view_local', name=item.name)}">Overview</a>
                %if request.has_permission('admin'):
                    <a href="${request.route_url('delete_local',name=item.name)}">Delete</a>
                %endif
                </p>

            %endif
                </div>
			%endfor
			</div>
            <hr class="uk-grid-divider">

		%endfor
		</div>
    </div>
%endif
</div>
%endfor
%endif
</div>
</div>

	</div>

</div>

</div>


