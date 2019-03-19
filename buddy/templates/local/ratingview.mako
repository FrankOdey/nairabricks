<div class="row">
                        <div class="col-sm-12">
                  <h2 style="color: #ff813d;"><b>Rating & Review of ${locality.city_name} in ${locality.state.name}</b></h2>
                            </div>
                            <%doc>
                        <div class="col-sm-4">
                            <form class="pull-right">
                        <label>State</label><select>
                                <option selected="${locality.state.name}">${locality.state.name}</option>
                            %for s in view.states:
                                %if not s.id==locality.state.id:
                            <option>${s.name}</option>
                            %endif
                            %endfor

                        </select>
                        <label>City</label>
                                <select>
                                    <option selected="${locality.city_name}">${locality.city_name}</option>
                                    %for s in locality.state.local:
                                        %if not s.id == locality.state.id:
                                            <option>${s.city_name}</option>
                                        %endif
                                    %endfor
                        </select>
                                <button type="submit" class="btn btn-danger btn-xs">Go</button>
                    </form>
                        </div>
                        </%doc>
                    </div>
                    <div class="text-center">
     <div id="overall"> <label>Overall Rating:</label> <input id="input-id" type="number" value="${locality.overall_avg}"
                                class="rating" min=0 max=5 data-size="xs"
                                                   data-show-caption="false" data-show-clear="false"
                                                   data-readonly="true"> ${locality.overall_avg}</div>
                       </div>
                       <div class="row">
                        %for ftype in ftypes:
                                    %if ftype.children:
                                        <div class="col-sm-4">
                                                <strong>${ftype.name}</strong>
                                                <ul class="list-unstyled" style="font-size: 10px">
                                            %for child in ftype.children:
                                                <li><label>${child.name}</label>:
                                                %if locality.rating:
                                                   <input type="number" class="rating" min=0 max=5 data-size="xs" value="${locality.ratingByFeature[child.name]}"
                                                   data-show-caption="false" data-show-clear="false" data-readonly="true">${locality.ratingByFeature[child.name]}
                                                %else:
                                                <input type="number" class="rating" min=0 max=5 data-size="xs" value=""
                                                data-show-caption="false" data-show-clear="false" data-readonly="true">
                                                %endif

                                                                    </li>
                                            %endfor
                                                    </ul>
                                            </div>
                                    %endif
                                    %endfor
        <div class="text-center"><a href="${request.route_url('rate_local',name=locality.city_name)}" class="btn btn-pink uk-button-small">Rate this city now</a></div>
                       </div>
                    <hr style="border-bottom:2px solid #ddd">
                    %for item in locality.rating:
                        <div class="uk-grid">
                            <div class="uk-width-1-1" >
                                <div class="media">
                        	<a  href="${request.route_url('profile', prefix=item.user.prefix)}" class="pull-left">
                          %if item.user.photo:
                          <img src="${request.storage.url(item.user.photo)}"  width="40" class="media-object"/>
                           %else:
                        <img  src="/static/male avater.png" width="40" class="media-object">

                        %endif
                        	</a>
                        <div class="media-body">
                                    <b>${item.title}</b>
                        	<li style="font-size: 10px"><input id="input-id" type="number" value="${item.avg_rating}"
                                                                  class="rating" min=0 max=5 data-size="xs"
                                                                    data-show-caption="false" data-show-clear="false"
                                                                     data-readonly="true"> ${item.avg_rating}</li>


                                <div class="uk-width-8-10">
                                    ${item.review}
                                </div>
                                %if request.has_permission("edit"):
                                <a href="${request.route_url('edit_local_rating',name=locality.name, rating_id = item.id)}" class="btn btn-pink btn-xs">Edit</a>
                                %endif
                                %if request.has_permission("edit"):
                                <a href="#confirm-modal" class="btn btn-danger btn-xs" data-uk-modal>Delete</a>
                          ${delete_modal("Are you sure you want to delete this review?",request.route_url('delete_local_rating', name=locality.name,rating_id=item.id))}
                                %endif
                            </div>
                            </div>
                            </div>
                            </div>

                    %endfor
