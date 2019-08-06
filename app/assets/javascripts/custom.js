/* File			:			custom.js
 * Author		:			ShivkAggarwal
 * Created Date	:			16-02-2018 (dd-mm-yyyy)
 * Purpose		:			Custom methods
 * */
$(document).ready(function() {
   window.setTimeout(function() {
      $(".alert").fadeTo(500, 0).slideUp(500, function(){
          $(this).remove();
      });
  }, 4000);

     var firstDiv = parseFloat($('#bank_content').height())
      var secondDiv = parseFloat($('#bank_details').height())
    if(firstDiv > secondDiv)
      {
      $('#bank_details').css( "height",firstDiv);
      }
    else
    {
      $('#bank_content').css( "height",secondDiv);
    }

     //console.clear();

	$("#adv-option").click(function(){
		if( $("#search-adv-option-inner").hasClass("display-adv-search")){
			$("#search-adv-option-inner").slideToggle("slow").removeClass("display-adv-search");
		} else {
			$("#search-adv-option-inner").addClass("display-adv-search").slideToggle("slow");
		}
	});
	// Show/hide signin/signup modals
	$('.signup-link-clr').on('click', function(){
    $('.login-popup').modal('hide');
		$('#forgot-popup').modal('hide');
	});
	$('.setLogin').on('click', function(){
		$('#signup-popup').modal('hide');
    $('#forgot-popup').modal('hide');
	});
  $('.setForgot').on('click', function(){
    $('#signup-popup').modal('hide');
    $('.login-popup').modal('hide');
  });

	$("#login_form").validate({
      rules: {
          "user[email]":{
            required: true,
            email: true
          },
          "user[password]":{
            required: true,
            minlength: 6
          }
      },
       messages: {
          "user[email]":{
            required: "Please enter email address."
          },
          "user[password]":{
            required: "Please enter password.",
            minlength: "Your password must be at least 6 characters long."
          }
       }
  })

  $('#signup_form').validate({
  		rules: {
          "user[first_name]":{
          	required: true,
          },
          "user[email]":{
            required: true,
            email: true
          },
          "user[password]":{
            required: true,
            minlength: 6
          },
          "user[password_confirmation]":{
          	required: true,
            minlength: 6,
          	//equalTo: '#user_password'
          }
      },
       messages: {
       		"user[first_name]":{
       			required: 'Please enter first name.'
       		},
          "user[email]":{
            required: "Please enter email address."
          },
        	"user[password]":{
        		required: 'Please enter password.',
            minlength: "Your password must be at least 6 characters long."
        	},
        	"user[password_confirmation]":{
        		required: 'Please enter confirm password.',
            minlength: "Your confirm password must be at least 6 characters long.",
            //equalTo: 'Please enter the same password again.'
        	}
       }

  })


  $('#sign_in_form').validate({
    rules: {
      "user[email]":{
        required: true,
        email: true,
      },
      "user[password]":{
       required: true,
        minlength: 6
      }
    },
    messages: {
      "user[email]":{
        required: "Please enter email address.",
        email: "Please enter valid email address.",
      },
      "user[password]":{
       required: "Please enter password.",
       minlength: "Your password must be at least 6 characters long."
      }

    }

  })

  $('#sign_up_form').validate({
    rules: {
      "user[first_name]":{
        required: true
      },
      "user[email]":{
        required: true,
        email: true,
      },
      "user[password]":{
       required: true,
        minlength: 6
      },
      "user[password_confirmation]":{
        required: true,
        minlength: 6,
        //equalTo: '#user_password'
      }
    },
    messages: {
      "user[first_name]":{
        required: "Please enter first name."
      },
      "user[email]":{
        required: "Please enter email address.",
        email: "Please enter valid email address.",
      },
      "user[password]":{
       required: "Please enter password.",
       minlength: "Your password must be at least 6 characters long."
      },
      "user[password_confirmation]":{
        required: "Please enter confirm password.",
        minlength: "Your confirm password must be at least 6 characters long.",
        //equalTo: 'Please enter the same password again.'
      }
    }
  })

  $("#forgot_signup_form").validate({
    rules: {
        "user[email]":{
          required: true,
          email: true
        }
    },
    messages: {
      "user[email]":{
        required: "Please enter email address.",
        email: "Please enter valid email address.",
      }
    }
  })

  $("#forgot_signup_form_pop").validate({
    rules: {
        "user[email]":{
          required: true,
          email: true
        }
    },
    messages: {
      "user[email]":{
        required: "Please enter email address.",
        email: "Please enter valid email address.",
      }
    }
  })

  $('#contact_us_form').validate({
    rules: {
      "name": {
          required: true
      },
      "email": {
          required: {
            depends:function(){
                $(this).val($.trim($(this).val()));
                return true;
              }
          },
          email: true
      },
      "question":{
          required: true
      }
    },
    messages: {
      "name": {
          required: "Please enter your name."
      },
      "email": {
          required: "Please enter your email.",
          email: "Please enter valid email address.",
      },
      "question":{
          required: "Please enter your question."
      }
    }
  });

  $('#user_profile_section').validate({
    rules: {
      "user[first_name]": {
          required: true
      },
      "user[email]": {
          required: {
            depends:function(){
                $(this).val($.trim($(this).val()));
                return true;
              }
          },
          email: true
      },
      "user[phone_number]":{
          required: true
      },
      "user[zip_code]": {
        required: true
      },
      "user[home_price]":{
        required: true
      },
      "user[down_payment]":{
        required: true
      }
    },
    messages: {
      "user[first_name]": {
          required: "Please enter your first name."
      },
      "user[email]": {
          required: "Please enter your email.",
          email: "Please enter valid email address."
      },
      "user[phone_number]":{
          required: "Please enter your mobile number."
      },
      "user[zip_code]": {
        required: "Please enter zip code."
      },
      "user[home_price]":{
        required: 'Please enter the home price.'
      },
      "user[down_payment]":{
        required: "Please enetr down_payment."
      }
    }
  })

  $('#user_password_section').validate({
    rules: {
      "user[current_password]":{
        required: true
      },
      "user[password]":{
        required: true,
        minlength: 6
      },
      "user[password_confirmation]":{
        required: true,
        minlength: 6
      }
    },
    messages: {
      "user[current_password]":{
        required: "Please enter current password."
      },
      "user[password]":{
        required: "Please enter password.",
        minlength: "Your password must be at least 6 characters long."
      },
      "user[password_confirmation]":{
        required: "Please enter confirm password.",
        minlength: "Your confirm password must be at least 6 characters long.",
      }
    }

  })

  $('#reset_password').validate({
    rules: {
      "user[password]": {
        required: true,
        minlength: 6
      },
      "user[password_confirmation]":{
        required: true,
        minlength: 6
      }
    },
    messages: {
      "user[password]":{
        required: "Please enter password.",
        minlength: "Your password must be at least 6 characters long."
      },
      "user[password_confirmation]":{
        required: "Please enter confirm password.",
        minlength: "Your confirm password must be at least 6 characters long.",
      }
    }
  })

});
