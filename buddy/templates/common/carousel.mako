<%namespace file="buddy:templates/listing/property/all.mako" import ="zdetails"/>
<%def name="carousel(listings)">

    <div id="carousel-listing-photos" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->

  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">

    <div class="item active">
        <div class="row">
        %for item in listings[:3]:

          <div class="col-md-4">
              ${zdetails(item)}
      </div>
        %endfor
        </div>
    </div>
%if len(listings)>3:
    <div class="item">
        <div class="row">
         %for item in listings[3:6]:

          <div class="col-md-4">
              ${zdetails(item)}
      </div>
    %endfor
            </div>
    </div>
%endif
      %if len(listings)>6:
    <div class="item">
        <div class="row">
         %for item in listings[6:9]:

          <div class="col-md-4">
              ${zdetails(item)}
      </div>
    %endfor
            </div>
    </div>
%endif
      %if len(listings)>9:
    <div class="item">
        <div class="row">
         %for item in listings[9:12]:

          <div class="col-md-4">
              ${zdetails(item)}
      </div>
    %endfor
            </div>
    </div>
%endif
      %if len(listings)>12:
    <div class="item">
        <div class="row">
         %for item in listings[12:15]:

          <div class="col-md-4">
              ${zdetails(item)}
      </div>
    %endfor
            </div>
    </div>
%endif



  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-listing-photos" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-listing-photos" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>

</%def>
<%def name="mobile_carousel(listings)">

    <div id="carousel-listing-photos-mobile" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->


  <!-- Wrapper for slides -->
  <div class="carousel-inner" role="listbox">
    <div class="item active">
              ${zdetails(listings[0])}
        </div>


%if len(listings)>1:
        %for item in listings[1:]:
    <div class="item">
              ${zdetails(item)}

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