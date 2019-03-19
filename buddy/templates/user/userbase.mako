<%inherit file="buddy:templates/base/layout.mako"/>
<%namespace file="buddy:templates/base/delete-modal.mako" import="delete_modal"/>

<%block name="script_tags">
<script type="text/javascript">
$(function(){
$('#contactForm').validate();
});
</script>
</%block>
<section class="profile-header">
    <div class="coverphoto"
    %if user.cover_photo:
        <%
            u=request.storage.url(user.cover_photo)
            u=u.replace('\\','/')
          %>
       style=" background-image:url('${u}');padding-top: 10px"
    %else:
     style=" background-image: url('/static/bg.jpg');padding-top: 10px"
    %endif
        >
        <div class="bg-overlay">
    <div class="container">

<div class="row">
    <div class="col-md-8 col-md-offset-2">
<div class="row">
         <div class="col-sm-4 text-center">
<div class="picture-widget">
%if user.photo:
<img src="${request.storage.url(user.photo)}" class=" profile-pix">
    %else:
    <img src="/static/default-picture.jpg" class=" profile-pix">
%endif
    </div>
         </div>
         <div class="col-sm-8">
             <div class="profile-info" itemscope="" itemtype="http://schema.org/localbusiness">
<p style="color: #fff;"><a class="profile-full-name" itemprop="name" href="${request.route_url('profile',prefix=user.prefix)}"></a>
   <span class="profile-username">${user.fullname}
    %if user.is_verified:
        <img src="/static/verified.png" width="15" data-toggle="tooltip" data-placement="bottom"
             title="Verified Professional" />
    %endif
       </span>
</p>
   <p  style="color: #fff"><span class="profile-username"> ${user.company_name or ''}</span></p>
<%doc>
<ul class="list-inline">
    <li style="font-size: 9px"><input id="input-id" type="number" value="${user.user_rating}"
           class="rating" min=0 max=5 data-size="xs"
          data-show-caption="false" data-show-clear="false"
          data-readonly="true"></li>
     <li class="label label-primary">${user.user_rating}</li>
</ul>
</%doc>
                 <ul class="list-inline" id="social-images">
                                    <li>
                                  %if user.fb:
                      <a href="${user.fb}" target="_blank"><img src="/static/socialis/Background/Color/Facebook.png"/></a>
                  %else:
                      <img src="/static/socialis/Background/Glyph/Facebook.png"/>
                  %endif
                                    </li>
                                    <li>
                  %if user.tw:
                      <a href="${user.tw}" target="_blank"><img src="/static/socialis/Background/Color/Twitter.png"/></a>
                  %else:
                        <img src="/static/socialis/Background/Glyph/Twitter.png"/>
                  %endif
                                        </li>
                                    <li>
                  %if user.linkedin:
                       <a href="${user.linkedin}" target="_blank"><img src="/static/socialis/Background/Color/LinkedIn.png"/></a>
                  %else:
                     <img src="/static/socialis/Background/Glyph/LinkedIn.png"/>
                  %endif
                                    </li>
                     <li><a href="#" class="btn btn-sm btn-pink" data-toggle="modal" data-target="#contactModal" style="border-radius:0">Contact</a></li>
##<li><a href="#" data-toggle="modal" class="btn btn-sm btn-warning" data-target="#ratingModal" style="border-radius:0">Add Review</a></li>
                                    </ul>
                 <%doc>
                    %if request.has_permission('superadmin'):
                                                                <a href="#confirm-modal" data-toggle="tooltip" title="Delete this user"
               class="btn btn-danger" style="border-radius:0" data-uk-modal> Delete <i class="uk-icon-times" ></i></a>
            ${delete_modal("Are you sure you want to delete %s from the website?"%user.fullname,request.route_url('delete_user',
            prefix=user.prefix))}
                       %endif
                       </%doc>

			</div>
				</div>

         </div>
        </div>
</div>
     </div>
        </div>
        </div>
    <div class="container">
 <%include file="profilenav.mako"/>

    <%include file="contact_agent.mako"/>
  ##  <%include file="rating.mako"/>
</div></section>
    <div class="container">
    ${next.body()}
    </div>