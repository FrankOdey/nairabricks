%if lga:
    <ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" />
</li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_state',state_name=lga.state.name)}">
        <span itemprop="name">${lga.state.name}</span></a>
        <meta itemprop="position" content="2" /></li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${lga.name}</span>
        <meta itemprop="position" content="2" /></li>
    </ol>
%elif state:
    <ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" />
</li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${state.name}</span>
        <meta itemprop="position" content="2" /></li>
    </ol>
    %elif district:
    <ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" />
</li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem">
        <a itemprop="item" href="${request.route_url('browse_state',state_name=district.lga.state.name)}">
        <span itemprop="name">${district.lga.state.name}</span></a>
        <meta itemprop="position" content="2" /></li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem">
        <a itemprop="item" href="${request.route_url('browse_region',region_id=district.lga.id,region_name=district.lga.name,state_name=district.lga.state.name)}">
            <span itemprop="name">${district.lga.name}</span></a>
        <meta itemprop="position" content="2" /></li>
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${district.name}</span>
        <meta itemprop="position" content="2" /></li>
    </ol>
    %elif category:
    <ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">
    <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="/"><span itemprop="name">Home</span></a>
    <meta itemprop="position" content="1" />
</li>
    %if category.parent:
         <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><a itemprop="item" href="${request.route_url('browse_category',category_id=category.parent.id,category_name=category.parent.name)}"><span itemprop="name" >${category.parent.name}</span></a>
        <meta itemprop="position" content="2" /></li>
     <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${category.name}</span>
        <meta itemprop="position" content="2" /></li>
    %else:
         <li itemprop="itemListElement" itemscope
      itemtype="http://schema.org/ListItem"><span itemprop="name">${category.name}</span>
        <meta itemprop="position" content="2" /></li>

    %endif
        </ol>
%endif