
<%def name="carousel(listing)">

    <div id="carousel-listing-photos" class="carousel slide" data-ride="carousel">
  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">

    <div class="item active">
        <div class="row">
        %for item in listing.pictures.all()[:4]:
            <div class="col-md-6">
        <div class="pixContainer">
              <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                  <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %if len(listing.pictures.all())>4:
          <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[4:8]:
            <div class="col-md-6">
        <div class="pixContainer">
        <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
            <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
      %if len(listing.pictures.all())>8:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[8:12]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
      %if len(listing.pictures.all())>12:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[12:16]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
     %if len(listing.pictures.all())>16:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[16:20]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
      %if len(listing.pictures.all())>20:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[20:24]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
      %if len(listing.pictures.all())>24:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[24:28]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
      %if len(listing.pictures.all())>28:
           <div class="item">
        <div class="row">
        %for item in listing.pictures.all()[28:32]:
            <div class="col-md-6">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor
        </div>
    </div>
      %endif
  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-listing-photos" role="button" data-slide="prev">
    <span class="fa fa-arrow-circle-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-listing-photos" role="button" data-slide="next">
    <span class="fa fa-arrow-circle-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

</%def>

<%def name="carousel_mobile(listing)">

    <div id="carousel-listing-photos-mobile" class="carousel slide" data-ride="carousel">
  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">

    <div class="item active">
        <div class="pixContainer">
              <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(listing.pictures.all()[0].filename)}">
                  <img class="img-resp" src="${request.storage.url(listing.pictures.all()[0].filename)}" alt="${listing.title}"></a>
      </div>

    </div>
      %if len(listing.pictures.all())>1:

        %for item in listing.pictures.all()[1:]:
            <div class="item">
        <div class="pixContainer">
            <a class="fancybox" rel="gallery" title="${listing.title}" href="${request.storage.url(item.filename)}">
                <img class="img-resp" src="${request.storage.url(item.filename)}" alt="${listing.title}"></a>
      </div>
        </div>
        %endfor

      %endif

  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-listing-photos-mobile" role="button" data-slide="prev">
    <span class="fa fa-arrow-circle-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-listing-photos-mobile" role="button" data-slide="next">
    <span class="fa fa-arrow-circle-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

</%def>