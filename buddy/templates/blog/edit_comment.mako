<%inherit file="buddy:templates/base/layout.mako"/>
<%block name="script_tags">
${parent.script_tags()}
<script>
    $(function(){
    $('#commentForm').validate();

    });
</script>
    </%block>
<div class="uk-container uk-container-center">
    <div class="uk-width-medium-1-2 uk-container-center">
        <div class="wrapper">
            <h2>${title}</h2>
            ${form.begin(method="post",id="commentForm",class_="form-horizontal")}
<input type="hidden" name="csrf_token" value="${get_csrf_token()}">
${form.hidden('blog_id',value=blog_id)}
${form.textarea(name="body" ,rows="3", class_="form-control required",placeholder="Leave a comment")}<br>
<button type="submit" name="form_submitted" class="btn btn-pink">Submit</button>
${form.end()}

        </div>
    </div>
</div>