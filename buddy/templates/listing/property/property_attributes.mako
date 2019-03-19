<div class="table-responsive">
<table class="table table-bordered table-striped  table-hover">
    <caption><b>Facts</b></caption>
    <tbody>


        %if category.bedroom:
        <tr><td><b>Bedrooms:</b> ${category.bedroom or 0}</td>

        <td><b>Bathrooms:</b> ${category.bathroom or 0}</td>
        %if not category.total_room:
            <td><b>Total rooms:</b> ${category.bedroom or 0}</td>
            %else:
            <td><b>Total rooms:</b> ${category.total_room or 0}</td>
        %endif
        </tr>
        %endif
        <tr><td><strong>Transaction type:</strong>${(listing.transaction_type)}</td>
        <td><strong>Area Size:</strong>${category.area_size}m&sup2;</td>
        <td><strong>Available from:</strong>${listing.available_from or 'Now'}</td>
        </tr>
    </tbody>
        <tbody class="complete">
        %if listing.category.name.lower() not in ['residential land', 'commercial land','hotel sites','agricultural land','industrial land']:

        <tr><td><b>Floor Number:</b>${category.floor_no or 'None'}</td>

        <td><b>Total Floors:</b>${category.total_floor}</td>
        <td><strong>Covered Area Size:</strong>${category.covered_area or ''}m&sup2;</td>
        </tr>
        <tr><td><strong>Year Built:</strong>${category.year_built or ''}</td>
        <td><strong>Furnished?:</strong>
        %if not category.furnished:
                No
                %else:
                Yes
        %endif
            </td>
         <td><strong>Car Spaces:</strong>${category.car_spaces or 'not stated'}</td>
        <tr>
            <tr>
                <td><b>Serviced?:</b>
                %if serviced:
                    yes
                        %else:
                    Not serviced
                %endif
                </td>
        </tr>
        %endif


        <tr><td><strong>Deposit:</strong> ${listing.deposit or "Contact agent"}</td>
        <td><strong>Agent Commission:</strong> ${listing.agent_commission or 'Not stated'}</td>
        <td><strong>Price Condition:</strong> ${listing.price_condition or "Not stated"}</td>
        </tr>


    </tbody>

</table>
    </div>
<span class="moretext">more..</span>
<span class="lesstext" style="display:none">less..</span>