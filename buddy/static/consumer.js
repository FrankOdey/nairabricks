function ajax(type, url, data, callback) {
        $.ajax({
            type: type,
            url: url,
            data: data,
            dataType: 'json',
			contentType: 'application/json; charset=utf-8',
            success: callback
        });
    }
function get(url, data, callback) {
		return ajax('GET', url, data, callback)
		}
function post(url, data, callback) {
	return ajax('POST', url, data, callback)
	}

	function getRootUrl() {
	return window.location.origin?window.location.origin+'/':window.location.protocol+'/'+window.location.host+'/';
}

$(document).ready(function(){
    var feedbackOptions = {
        target:"#feedback"
    };
    var ChangeEmail = $("#ChangeEmailAndPassword");
    ChangeEmail.validate({
        rules: {
            email: {
                required: true,
                email: true,
                remote: {
                    url: getRootUrl() + 'account/check-email',
                    type: "post",
                    data: {
                        csrf_token: function () {
                            return $("#csrf_token").val();
                        }
                    }
                }
            },
            old_password: {
                required: true,
                remote: {
                    url: getRootUrl() + 'account/check-oldpassword',
                    type: "post",
                    data: {
                        csrf_token: function () {
                            return $("#csrf_token").val();
                        }
                    }
                }
            },
            password: {required: true, minlength: 6},
            confirm_password: {
                required: true,
                minlength: 6,
                equalTo: "#password"
            }
        }
    });
    ChangeEmail.ajaxForm(feedbackOptions);
var PersonalDetails = $('#personal-form');
     PersonalDetails.validate({
            rules:{
                fb:{
                    url:true
                },
                tw:{url:true
                },
                linkedin:{
                    url:true
                },
                prefix:{required:true}
            }

        });
    PersonalDetails.ajaxForm(feedbackOptions);
    AboutFm = $('#abtfm');
     AboutFm.validate();
     AboutFm.ajaxForm(feedbackOptions)
    var ContactOptions = {
        target:"#feedback"
    };
    $(".agentForm").ajaxForm(ContactOptions);


$('.make-favourites').click(function(){
    var that = $(this);
    var value = that.attr('data-value');
    var positive = that.attr('data-positive');
    var data  = {id:value,positive:positive}

    $.get("/users/save_favourites",JSON.stringify(data),function(resp){
        if (resp.isOk){
        if (positive==1){
        that.attr('data-positive',0);
        that.html('');
        that.html("<span class='glyphicon glyphicon-heart-empty'></span> Save");
        that.attr('data-original-title',"Save");

        }
        else {
        that.attr('data-positive',1);
        that.html('');
        that.html("<span class='glyphicon glyphicon-heart'></span> Saved");
        that.attr('data-original-title',"Saved");
        }

        }
    })

});

$('.approve-property').click(function(){
    var that = $(this);
    var value = that.attr('data-value');
    var data  = {id:value};
    $.get("/listings-ajax/approve-listing",data,function(resp){
        if (resp.isOk){
        that.html("Approved");
        $("#message-info").html(resp.message)
        }
        else {
        $("#message-info").html(resp.message)
        }
    });
});
$('.decline-property').click(function(){
    var that = $(this);
    var value = that.attr('data-value');
    var data  = {id:value};
    $.get("/listings-ajax/decline-listing",data,function(resp){
        if (resp.isOk){
            that.html("Declined");
        $("#message-info").html(resp.message)
        }
    });
});
$(".sold").click(function(){
    var that = $(this);
    var value = that.attr("data-id");
    $("#soldform").show('slow');
    $("#update-listing").hide('slow');
    $(".sold").hide();
});
 $("#listing-submit-clicked").click(function(){
        price=$("#price").val();
        token = $("#token").val();
        var data = {id:value,price:price,token:token};
        $.get("/listings-ajax/markassold",data,function(resp){
            if (resp.isOk){
                $("#editLanding").modal("hide");
                $("#Editinfo").show();
                that.attr('disabled','disabled')
                }
         });
    });
$('.make-premium').click(function(){
    var that = $(this);
    var value = that.attr('data-value');
    var positive = that.attr('data-positive');
    var user_id = that.attr('data-user_id');
    var data  = {id:value,positive:positive,user_id:user_id}
    $.get("/listings-ajax/make-premium-listing",JSON.stringify(data),function(resp){
        if (resp.isOk){
        if (positive==1){
        that.attr('data-positive',0);
        that.html("Make Premium");
        $('#message-info').html(resp.message)}
        else {
         that.attr('data-positive',1);
        that.html("Remove Premium")};
        $('#message-info').html(resp.message)
        }
        else {
            $('#message-info').html(resp.message)
        }
    });
});
$('.userView').popover({
	container:"body",
	content:'',
	animation:true,
	html:true,
	trigger:"hover",
	placement:"top"

});


$('.price').priceFormat({
            prefix:'\u20a6 ',
            centsLimit:0
        });

var sortAlphabetical = function(a, b){
                         if(a.label < b.label) return -1;
                            if(a.label > b.label) return 1;
                            return 0;
};

 var getsubcategory = function (data) {

  $.get("/listings-ajax/lgas-ajax",data, function(resp){
                var lgaid = $('.lga_id');
				lgaid.html('');
                lgaid.append('<option value='+""+'>' + "Any Region" + '</option>');
                resp.sort(sortAlphabetical)
				$.map( resp, function( item, index ) {
					var option =$('<option value=' + item.value + '>' + item.label + '</option>');
				lgaid.append(option);
				});
			});
	};
$('.state_id').on('change', function(){
	$selected=$('.state_id option:selected').val();
	$data = {id:$selected};
	getsubcategory($data);
	});
$('#s_id').on('change', function(){
	$selected=$('#s_id option:selected').val();
	$data = {id:$selected};
	getsubcategory($data);
	});
$('#show-advanced').click(function(){
    $('#advanced-search').slideToggle('slow');
});
    $('.md-advanced-show').click(function(){
    $('.md-advanced-search').slideToggle('slow');
});
 var hashTagActive = "";
    $(".scroll").click(function (event) {
        if(hashTagActive != this.hash) { //this will prevent if the user click several times the same link to freeze the scroll.
            event.preventDefault();
            //calculate destination place
            var dest = 0;
            if ($(this.hash).offset().top > $(document).height() - $(window).height()) {
                dest = $(document).height() - $(window).height();
            } else {
                dest = $(this.hash).offset().top;
            }
            //go to destination
            $('html,body').animate({
                scrollTop: dest
            }, 2000, 'swing');
            hashTagActive = this.hash;
        }
    });
 });



