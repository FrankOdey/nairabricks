<%inherit file="buddy:templates/base/layout.mako"/>

<div class="container">
    <ul class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList"><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" /></li><li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name"> Good neighbour policy</span><meta itemprop="position" content="2" /></li></ul>
    <div class="row">
        <div class="col-md-12">
            <div class="hz_yt_bg">
                <article>
                    <div class="page-header">Good Neighbor Policy</div>
                    We invite you to write blog posts, ask questions and submit answers on nairabricks , but in doing so,
                    we ask that you follow our Good Neighbor Policy:
                    <hr>
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="text-center">
                            <img src="/static/thumbs-up.png" width="50"/> <b>Good</b>
                                </div>
                            <h4>Be respectful of others:</h4>

                        <ul class="uk-list-space">
                            <li>Be honest</li>
                              <li>Post information that is appropriate and in context with real estate</li>
                               <li>Use good judgment</li>
                               <li>Think <a href="https://en.wikipedia.org/wiki/Golden_Rule" target="_blank">Golden Rule</a></li>
                                <li>Respect the privacy of your neighbors</li>
                        </ul>
                            </div>
                        <div class="col-sm-6">
                            <div class="text-center">
                            <img src="/static/thumbs-down.png" width="50"/> <b>Not So Good</b>
                                </div>
                            <h4>Please don't post inappropriate stuff:</h4>
                            <ul class="uk-list-space" >
                            <li>Stating a discriminatory preference in an advertisement for housing is illegal</li>
                            <li>Any other discriminatory, abusive, obscene, threatening, or libelous content</li>
                            <li>Other illegal communication, or disclosure of confidential or sensitive information</li>
                            <li>Uploading photos or content that infringes copyright</li>
                            <li>Spam, advertising, or self-promotional content is not allowed. This includes, but is not limited to,
                            any contact information such as phone numbers, email addresses, or website URLs
                            </li>
                                </ul>
                        </div>
                    </div>
<h3>The Bottom Line</h3>

<p>If we feel any content is inappropriate or off-topic, we reserve the right to remove it and, if we deem necessary, restrict access.</p>

<p>Basically, respect other folks on the site. Be a good neighbor. And, if you see anything that is inappropriate, please report it.</p>

<p>That's it! We enjoy having you here and want to thank you for helping make Nairabricks more useful for everyone.</p>

<p>The Nairabricks Team</p>

<small>For more information, please read our <a href="${request.route_url('privacy')}">Privacy Policy</a> and <a href="${request.route_url('terms')}">Terms of Use</a>. (Nodding off while you read these pages is not allowed.)</small>
                    </article>
            </div>

        </div>
    </div>
</div>