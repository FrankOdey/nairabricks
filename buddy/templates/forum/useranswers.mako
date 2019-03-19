<%inherit file="buddy:templates/user/userbase.mako"/>

<div class="row">
    <div class="col-sm-8">
        <div class="hz_yt_bg">
        <!-- Answer Begins -->
                           <div class="h4"><b>Answers <span class="text-muted">(${total_answers})</span>
                                                      %if qa:
                                                      <small><a href="${request.route_url('user_answers', prefix= user.prefix)}" style="color: #0044cc" >view all</a></small>
                                                      %endif
                                                      </b>
                                                      </div>
                                                          <hr>
                    %if answers:
                                    <div class="col-sm-offset-1">
                                    <ul class="list-unstyled">
                                    %for a in answers:
                                        %if not a.anonymous:
                                            <li><a href="${request.route_url('view_question',name=a.question.name)}">${a.question.title}</a></li>
                                                <li class="text-muted">
                                                    Asked ${a.question.timestamp} by
                                                    %if not a.question.anonymous:
                                                        <a href = "${request.route_url('profile',prefix=a.question.user.prefix)}">${a.question.user.fullname}</a>

                                                    %else:
                                                        Anonymous
                                                    %endif

                                                    %if a.question.categories:
                                                    %for cate in a.question.categories:
                         <span class="sep">&bull;</span>  <a href="${request.route_url('question_category_filter',filter=cate.name)}">${cate.name}</a><span class="sep"></span>
                                                     %endfor
                                                    %endif

                                                    </li>
                                            <li> ${h.truncate(a.body, length=300)|n}</li>
                                            <li class="text-muted">Answered by  <a href = "${request.route_url('profile',prefix=a.user.prefix)}">${a.user.fullname}</a>
                                                ${a.timestamp}
                                            </li>
                                         %endif
                                        <hr style="border-bottom:1px solid #ddd">
                                    %endfor
                                    </ul>
                                    </div>
                                %else:
                                    <p  class="text-muted">${user.fullname} have not answered any questions yet.</p>
                                %endif


    </div>
        </div>
    <div class="col-sm-4"></div>
</div>