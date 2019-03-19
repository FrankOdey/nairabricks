<%inherit file="buddy:templates/user/userbase.mako"/>
<div class="row">
    <div class="col-sm-8">
        <div class="hz_yt_bg">
         <div class="h4"><b>Questions <span class="text-muted">(${len(user.content.filter_by(type=u'question').all())})</span>
                           %if qa:
                           <small><a href="${request.route_url('user_questions', prefix= user.prefix)}" style="color: #0044cc" >view all</a></small>
                           %endif
                           </b>
                           </div>
                               <hr>
                               %if not qa:
                           <p class="text-muted">${user.fullname} have not asked any question yet</p>
                           %else:
                           <!-- Question Start -->
                           %for item in qa[:2]:

                   <div class="media" id="media">
                   	<a class="pull-left" href="">
                   %if item.user.photo:
                     <img src="${request.storage.url(item.user.photo)}" class="media-object img-responsive " width="40"/>
                      %else:
                   <img class="media-object img-responsive" src="/static/male avater.png" width="40">
                   %endif
                   	</a>
                   	<div class="media-body">
                   	<h4 class="media-heading"><a href="
                   ${request.route_url('view_question',name=item.name
                   			)}">${item.title}</a></h4>
                   	${item.excerpt}
                   %if item.excerpt!=None and len(item.body)>200:
                   <a href="${request.route_url('view_question',
                   						name=item.name)}">Read More</a>
                   %endif
                   	<div class="timestamp">
                   Asked ${item.timestamp} by
                   %if item.anonymous:
                   	Anonymous
                   %else:
                   <a href="${request.route_url('profile',prefix=item.user.prefix)}">${item.user.fullname}</a>
                   %endif
                     under <span class="uk-icon-arrow-right"></span>
                     %if item.categories:
                   	%for cate in item.categories:
                   	<span class="sep">&bull;</span>  <a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
                   	%endfor
                   %endif

                   <div class="comment">
                   %if item.answers:
                   	<a href="${request.route_url('view_question',name=item.name)}#answers">${len(item.answers)} Answers</a>
                   	<span class="sep">.</span>
                   	<a href="${request.route_url('view_question',name=item.name)}#answerForm">Answer this question</a>

                   %else:
                          No Answers
                         <span class="sep">.</span>
                         <a href="${request.route_url('view_question',name=item.name)}#answerForm">Be the first to Answer</a>
                   	<span class="sep">.</span>
                   <input type="hidden" id="csrf" name="csfr_token" value="${request.session.get_csrf_token()}"/>
                   	<a href=""><span data-value="${item.id}" data-toggle="tooltip" data-placement="bottom" title="This question is useful and clear" class="glyphicon glyphicon-thumbs-up vote-up"></span></a>

                   <span class="sep">&bull;</span>
                   <a href=""><span class="glyphicon glyphicon-flag"></span></a>

                   %endif
                                             </div>
                   		</div>
                   	</div>
                   </div>
                   %endfor
                                   %endif
    </div>
        </div>
    <div class="col-sm-4">

    </div>

</div>