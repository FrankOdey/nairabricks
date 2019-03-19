<ul class="uk-nav uk-nav-side">
                                    <li class="${'uk-active' if account else ''}"><a href="${request.route_url('account')}"><i class="uk-icon-home"></i> My Account</a></li>
                                    <li><a href="${request.route_url('profile', prefix=request.user.prefix)}"><i class="uk-icon-user"></i> Profile</a></li>
                                    <li class="${'uk-active' if saved else ''}"><a href="${request.route_url('favourite_properties', prefix=request.user.prefix)}" data-toggle="tooltip" title="Favourite Properties"><i class="uk-icon-heart"></i> Favourites</a></li>
                                    <li class="${'uk-active' if mess else ''}"><a href="${request.route_url('inbox',id=request.user.id)}"><i class="uk-icon-envelope"></i> Messages
                                    %if request.user.messages:
                            %if request.user.total_unseen_messages>0:

                            <div class="uk-badge uk-badge-notification uk-badge-warning">${request.user.total_unseen_messages}</div>
                                %endif
                        %endif
                                    </a></li>
                                    <li class="${'uk-active' if lis else ''}"><a href="${request.route_url('user_listings', prefix= request.user.prefix)}"><i class="uk-icon-building-o"></i> My Listings</a></li>
                                   ## <li  class="${'uk-active' if bl else ''}"><a href="${request.route_url('user_blog', prefix= request.user.prefix)}"><i class="uk-icon-book"></i> My Blogs</a></li>
                                   ## <li class="${'uk-active' if q else ''}"><a href="${request.route_url('user_questions', prefix= request.user.prefix)}"><i class="uk-icon-question-circle"></i> My Questions</a></li>
                                   ## <li class="${'uk-active' if a else ''}"><a href="${request.route_url('user_answers', prefix= request.user.prefix)}"><i class="uk-icon-file-text-o"></i> My Answers</a></li>
                                    <li class="${'uk-active' if rv else ''}"><a href="${request.route_url('user_ratings_and_reviews',prefix=request.user.prefix)}"><i class="uk-icon-star"></i> Reviews </a></li>
                                   ## <li class="${'uk-active' if wb else ''}"><a href="${request.route_url('add_blog')}"><i class="uk-icon-pencil"></i> Write a Blog Post</a></li>
                                  ##  <li class="${'uk-active' if aq else ''}"><a href="${request.route_url('ask_questions')}"><i class="uk-icon-pencil-square-o"></i> Ask Question</a></li>
                                    <li class="${'uk-active' if ed else ''}"><a href="${request.route_url('user_edit', prefix=request.user.prefix)}"><i class="uk-icon-cog"></i> Edit profile</a></li>
                                    </ul>
