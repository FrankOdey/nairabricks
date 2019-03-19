$(function(){
    var getsubcategory = function (data) {
  $.get("/listings-ajax/lgas-ajax",data, function(resp){
				$('.lga_id').html('');
				$.map( resp, function( item, index ) {
					var option =$('<option value=' + item.value + '>' + item.label + '</option>');
				$('.lga_id').append(option);
				});
			});
	};

$('.state_id').on('change', function(){
	$selected=$('.state_id option:selected').val();
	$data = {id:$selected};
	getsubcategory($data);
	});
// category selection on listing creation

  $('#add-listing-step-1').addClass('active');

  //tooltips
  $('#wizard_start #show_address').tooltip({
	title:"Uncheck this box to hide this address",
	animation:true,
	placement:"bottom"
	});
$('#wizard_start #title').tooltip({
	container:"body",
	title:"Please write a nice title for your property. This makes your property easily available on search engines",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start .location').tooltip({
	container:"body",
	title:"Fill up the region and area field, there is awesomeness in specifics",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #address').tooltip({
	container:"body",
	title:"You have to enter the address of your property. \n"
			+"However, if you don't want it to be shown on the website,\n"
			+"please uncheck the checkbox below it",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start .personal').tooltip({
	container:"body",
	title:"Please fill in your contact details.\n"
			+"Your mobile number is required \n"
			+"you can also fill in your other numbers. This will affect your profile",
	animation:true,
	trigger:"hover",
	placement:"top"
	});

    $('#wizard_start #price').tooltip({
	container:"body",
	title:"What is the price of this property.",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #deposit').tooltip({
	container:"body",
	title:"Is there any deposit a buyer need to make to own this property?. \n"
			+"If there is,Please enter it. You may enter it in percentage",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #agent_commission').tooltip({
	container:"body",
	title:"What is agent's commission  for this property?. \n"
			+"If there is any, please enter it. This field is optional and can be in %",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #price_available').tooltip({
	container:"body",
	title:"Uncheck this box if you don't want the price to be shown",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #price_condition').tooltip({
	container:"body",
	title:"Are there conditions to the price of this property? \n"
			+"If any, you may wish to write it down",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #transaction_type').tooltip({
	container:"body",
	title:"Is this a new property? A resale? A foreclosure? please select",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #bedroom').tooltip({
	container:"body",
	title:"Enter the total number of bedrooms in this property",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #bathroom').tooltip({
	container:"body",
	title:"Enter the total number of bathrooms in this property",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #total_room').tooltip({
	container:"body",
	title:"Enter the total number of rooms in this property, bathrooms inclusive",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #year_built').tooltip({
	container:"body",
	title:"When was this property built? No more that four digits is required",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #area_size').tooltip({
	container:"body",
	title:"The land size of this property in metre squared.",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #covered_area').tooltip({
	container:"body",
	title:"The area of the total land size covered by this property",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #car_spaces').tooltip({
	container:"body",
	title:"Is there a car space? How many cars can it contain? \n"
			+"Please answer this. Note that it's optional",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #furnished').tooltip({
	container:"body",
	title:"Is this property fully furnished? Please select",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #floor_no').tooltip({
	container:"body",
	title:"On which floor is this apartment? This option is optional",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #total_floor').tooltip({
	container:"body",
	title:"How many floor is this building",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #hospital').tooltip({
	container:"body",
	title:"How far is this property to hospital",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #market').tooltip({
	container:"body",
	title:"How far is this property to market or mall",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #school').tooltip({
	container:"body",
	title:"How far is this property to school",
	animation:true,
	trigger:"hover",
	placement:"top"
	});
$('#wizard_start #bank').tooltip({
	container:"body",
	title:"How far is this property to bank or ATM",
	animation:true,
	trigger:"hover",
	placement:"top"
	});

$('#wizard_start #available_from').tooltip({
	container:"body",
	title:"When is this property available? if it is available now, please enter 'Now'",
	animation:true,
	trigger:"hover",
	placement:"bottom"
	});
$('#wizard_start #body').popover({
	container:"body",
	content:"Describe your property to inform users, \n"
			+"build their trust, and answer their \n"
			+"questions. Don't forget information on \n"
			+"<ul><li> Property condition and facilities \r\n"
			+"</li><li> Location and neighbourhood  \r\n"
			+"</li><li> Yourself as the landlord or seller \r\n"
			+"</li></ul>Provide detailed, easy-to-read information \n"
			+"on notable features or a good story \n"
			+"associated with the property.",
	animation:true,
	html:true,
	trigger:"hover",
	placement:"top"
	});
});
