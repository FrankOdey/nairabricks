<div class="hz_yt_bg">
 <ul class="nav nav-pills">
 <li class="${'active' if profile_page else ''}"><a href="${request.route_url('profile',prefix=user.prefix)}" style="border-radius:0">Overview</a></li>
##<li class="${'active' if rating_page else ''}"><a href="${request.route_url('user_ratings_and_reviews',prefix=user.prefix)}" style="border-radius:0">Ratings & Review</a></li>
<li class="${'active' if lis else ''}"><a href="${request.route_url('user_listings', prefix= user.prefix)}" style="border-radius:0">Listings</a></li>
<li class="${'active' if bl else ''}"><a href="${request.route_url('user_blog', prefix= user.prefix)}" style="border-radius:0">Blogs</a></li>
##<li class="${'active' if q else ''}"><a href="${request.route_url('user_questions', prefix= user.prefix)}" style="border-radius:0">Questions</a></li>
##<li class="${'active' if a else ''}"><a href="${request.route_url('user_answers', prefix= user.prefix)}"  style="border-radius:0">Answers</a></li>
## <li class="${'active' if saved else ''}"><a href="${request.route_url('favourite_properties', prefix= user.prefix)}"  style="border-radius:0">Favourites</a></li>

</ul>
    </div>