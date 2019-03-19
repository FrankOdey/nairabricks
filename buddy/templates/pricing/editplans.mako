<%inherit file="buddy:templates/dash/base.mako"/>
<%namespace file="listplans.mako" import="create_plan"/>


<section>
    ${create_plan()}
</section>
