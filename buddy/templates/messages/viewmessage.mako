<%inherit file="buddy:templates/base/layout.mako"/>
<div class="uk-container uk-container-center">
    <div class="uk-grid">
    <div class="uk-width-medium-3-10 uk-hidden-small">
        <div class="wrapper">
<%include file="buddy:templates/user/accountNav.mako"/>
        </div>
        </div>
    <div class="uk-width-medium-7-10">
        <div class="wrapper">

%if message:
<p><b>From :</b> ${message.sender.fullname}</p>
    <p><b>Date :</b> ${message.created}</p>
    <b>Message: </b> <br>
    ${message.body|n}
%endif
</div>
    </div>
    </div>
  </div>