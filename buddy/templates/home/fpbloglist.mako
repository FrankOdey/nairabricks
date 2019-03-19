<%!
import string, os
from bs4 import BeautifulSoup

%>
%if blogs:
     <%
    table = h.distribute(blogs,4,'H')
    %>
         %for row in table:
             <div class="row">
             %for item in row:
                 %if item:
         <%
          soup = BeautifulSoup(item.body,'html.parser')
          fimage = soup.img

        %>
            <div class="col-md-3">
                <div class="hz_yt_bg">
    <div class="media">
        <a href="${request.route_url('blog_view',name=item.name)}" >
        %if fimage:
            <%
          base_path,filename = os.path.split(fimage['src'])
          outfile = os.path.splitext(filename)[0]+'_t.jpg'
          fileobj = os.path.join(base_path,outfile).replace('\\','/')

          %>
             <img src="${fileobj}" class="media-object " alt="${item.title}" width="250" height="150" >
            %else:
        <img src="https://placehold.it/250x150?text=No+Image" alt="${item.title}" class="media-object"/>
        %endif
            </a>
      <div class="media-body " style="padding-top: 10px">
        <h4 class="media-heading"><a href="${request.route_url('blog_view',name=item.name)}">${item.title.capitalize()}</a></h4>
        <p>${item.excerpt}</p>
        <p><a href="${request.route_url('blog_view',name=item.name)}" class="btn btn-site" role="button">Read more</a></p>
      </div>
    </div>
                    </div>
  </div>
                 %endif
             %endfor
             </div>
         %endfor

%endif


