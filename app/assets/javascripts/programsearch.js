$(document).ready(function () {
    var tab_val = $('.active .js-trigger').attr('data-tab');
    load_more(tab_val);
    average_closing_cost(tab_val,20)
    $('.tab-btn').click(function (e) {

      tab_val = $(this).text().replace ( /[^\d.]/g, '' ); 
      load_more(tab_val);
    });

    tab_term =  $('.active .js-trigger').attr('data-tab');
    $('.js-trigger').click(function(){
      $(".loader").show();
      $("#"+tab_term+"years").removeClass("active");
      
      tab_term = $(this).text().replace ( /[^\d.]/g, '' );
      if (tab_term=="51") {
        $(".arm-basic").show();
        $("#term").val('');
        $(".term").hide();
        $('#loan_type').val("ARM");
        $('.term_30').prop('checked', false);
        $('.term_15').prop('checked', false);
        $('.term_10').prop('checked', false);
        $('.arm_basic_7').prop('checked', false);
        $('.arm_basic_5').prop('checked', true);

      }else{
        $('#loan_type').val("Fixed");
        if (tab_term=="15") {
          $('.term_30').prop('checked', false);
          $('.term_10').prop('checked', false);
          $('.arm_basic_7').prop('checked', false);
          $('.arm_basic_5').prop('checked', false);
          $('.term_15').prop('checked', true);
        }else{
          $('.term_10').prop('checked', false);
          $('.arm_basic_7').prop('checked', false);
          $('.arm_basic_5').prop('checked', false);
          $('.term_15').prop('checked', false);
          $('.term_30').prop('checked', true);
        }
      }

      var data = $("#search_form").serialize();
      data = data+'&commit=commit'
      $.ajax({
        url: '/',
        type: "GET",
        dataType: "script",
        data: data,
        success: function(response) {
          $(".loader").hide();
        }
      });
    });

    $('.menu-up-adv-search').click(function(){
      $("#search-adv-option-inner").hide("fast").removeClass("display-adv-search");
    });
  
      $('.state').change(function(){
          id_passed = $(".state option:selected").val();
          $.ajax({
              url: '/pages/expert_state_and_city',
              type: "GET",
              dataType: 'json',
              data: {"state" : id_passed},
              success: function(response) {
                $(".city").empty();
                $.each(response, function(e,res){
                  $(".city").append($("<option></option>").attr("value",res).text(res));
                })
              }
          });
      })
  
      $('.city').change(function(){
          id_passed = $(".city option:selected").val();
          $.ajax({
              url: '/pages/expert_city_and_zip',
              type: "GET",
              dataType: 'json',
              data: {"city" : id_passed},
              success: function(response) {
                $(".zip").empty();
                $.each(response, function(e,res){
                  $(".zip").append($("<option></option>").attr("value",res).text(res));
                })
              }
          });
      })

      $.validator.addMethod('filesize', function (value, element, param) {
          return this.optional(element) || (element.files[0].size <= param)
      }, 'File size must be less than 2-Mb');

      $('#expert_user_form').validate({
        rules: {
          "expert[first_name]": {
              required: true
          },
          "expert[last_name]": {
              required: true
          },
          "expert[phone]":{
            required: true
          },
          "expert[email]": {
              required: {
                depends:function(){
                    $(this).val($.trim($(this).val()));
                    return true;
                  }
              },
              email: true
          },
          "expert[state]":{
            required: true
          },
          "expert[city]":{
            required: true
          },
          "expert[zip]":{
            required: true
          },
          "expert[license_number]":{
              required: true
          },
          "expert[website]":{
            required: true
          },
          "expert[image]": {
            required: true,
            extension: "jpg,jpeg",
            filesize:   2097152
          }
        },
        messages: {
          "expert[first_name]": {
              required: "Please enter your first name."
          },
          "expert[last_name]": {
              required: "Please enter you last name."
          },
          "expert[phone]":{
            required: "Plese enter mobile number."
          },
          "expert[email]": {
              required: "Please enter your email.",
              email: "Please enter valid email address.",
          },
          "expert[state]":{
              required: "Please selcet a state"
          },
          "expert[city]":{
              required: "Please selcet a city"
          },
          "expert[zip]":{
              required: "Please selcet a zip"
          },
          "expert[license_number]":{
              required: "Please enter your license number."
          },
          "expert[website]":{
            required: "Please enter website."
          },
          "expert[image]": {
            required: "Please upload an image.",
            extension: "File must be JPG,JPEG."
          }
        }
      })

      var fannie_mae = false
      $('#fannie_mae_du').click(function () {
        if ($(this).prop("checked")){
          fannie_mae = $('#fannie_mae').prop("checked")
          $('#fannie_mae').prop('checked', true);
        } else {
          $('#fannie_mae').prop('checked', fannie_mae);
        }
      });

      $('.arm_basic_7, .arm_basic_5').click(function () {
        if ($(this).prop("checked"))
          $('#loan_type').val("ARM")
        else
          $('#loan_type').val('')
      });

      $('.term_30, .term_15, .term_10').click(function () {
        if ($(this).prop("checked"))
          $('#loan_type').val("Fixed")
        else
          $('#loan_type').val('')
      });

      var freddie_mac = false
      $('#freddie_mac_lp').click(function () {
        if ($(this).prop("checked")){
          freddie_mac = $('#freddie_mac').prop("checked")
          $('#freddie_mac').prop('checked', true);
        } else {
          $('#freddie_mac').prop('checked', freddie_mac);
        }
      });

      var fha_checked = false
      var loan_purpose_value = $('#loan_purpose').val();
      $('#streamline').click(function () {
        if ($(this).prop("checked")){
          fha_checked = $('#fha').prop("checked")
          loan_purpose_value = $('#loan_purpose').val();
          $("#loan_purpose").val('Refinance');
          $("#adv_loan_purpose").val('Refinance');
          $('#fha').prop('checked', true);
          $('#loan_purpose-error').hide();
        } else {
          $('#fha').prop('checked', fha_checked);
          $("#loan_purpose").val(loan_purpose_value)
          $("#adv_loan_purpose").val(loan_purpose_value)

          $('.error-loan-purpose').hide();
        }
      });

      //loan_purpose default error hide
      $('#loan_purpose').change(function () {
        $('.error-loan-purpose').hide()
        $('#adv_loan_purpose').val($('#loan_purpose').val())
      });
      
      $('#adv_loan_purpose').change(function () {
        $('.error-loan-purpose').hide()
        $('#loan_purpose').val($('#adv_loan_purpose').val())
      });

      //when select fannie_mae_product fannie_mae will be true
      $('#fannie_mae_product').click(function () {
        if ($(this).prop("checked")){
          $('#fannie_mae').prop('checked', true);
        } else {
          $('#fannie_mae').prop('checked', false);
        }
      });

      $('#freddie_mac_product').click(function () {
        if ($(this).prop("checked")){
          $('#freddie_mac').prop('checked', true);
        } else {
          $('#freddie_mac').prop('checked', false);
        }
      });

      $('#reset_all_btn').click(function(event){
        $('input:checkbox').prop('checked', false);
        $('input[type="radio"]').prop('checked', false);
        $('#state').val('All');
        $('#loan_purpose').val('Purchase');
        $('#adv_loan_purpose').val('Purchase');
        $('#home_price').val('300000');
        $('#down_payment').val('50000');
        $('#credit_score').val('700-719');
        $('.term_30').prop('checked', true);
        $('#point_0').prop('checked', true);
        $('#lock_period').val('30');
      });

      $('.check').on('change', function() {
        $('.check').not(this).prop('checked', false); 
      });

      $('.refinance_checkbox').on('change', function() {
        $('.refinance_checkbox').not(this).prop('checked', false); 
      });


    function load_more(tab_val){
      var size_li = $("#"+tab_val+"years .demo-items-"+tab_val).length;
      // $("."+tab_val+"years").addClass('active')
      $("#"+tab_val+"years .demo-items-"+tab_val).hide();
      x=20;
      $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")").show();
      $('#loadMore').click(function () {
        x = (x+10 <= size_li) ? x+10 : size_li;
        average_closing_cost(tab_val,x)
        $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")").show();
      });
    }

    function average_closing_cost(tab_val,x){
      var size_li = $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")")
      var air_total = 0
      var apr_total = 0
      var saving_total = 0
      var monthly_payment_total = 0
      var closing_cost_total = 0
      for (i = 0; i < size_li.length; i++) { 
        air = size_li[i].querySelector('.a_air').textContent.trim().split('%')[0];
        apr = size_li[i].querySelector('.a_apr').textContent.trim().split('%')[0];
        saving = size_li[i].querySelector('.a_saving').textContent.trim().replace(/[$\,]/g,"")
        monthly_payment = size_li[i].querySelector('.a_monthly_payment').textContent.trim().replace(/\,/g,"").split('$')[1];
        closing_cost = size_li[i].querySelector('.a_closing_cost').textContent.trim().replace(/\,/g,"").split('$')[1];
        air = parseFloat(air);
        apr = parseFloat(apr);
        saving = parseInt(saving);
        monthly_payment = parseInt(monthly_payment);
        closing_cost = parseInt(closing_cost);
        air_total += air
        apr_total += apr
        saving_total += saving
        monthly_payment_total += monthly_payment
        closing_cost_total += closing_cost
      }
        avg_air = (air_total/size_li.length).toFixed(3)
        avg_apr = (apr_total/size_li.length).toFixed(3)
        avg_saving = "$"+(saving_total/size_li.length).toFixed(3)
        avg_monthly_payment = "$"+(monthly_payment_total/size_li.length).toFixed(3)
        avg_closing_cost = "$"+(closing_cost_total/size_li.length).toFixed(3)

        document.getElementById("air_avg").innerHTML = avg_air;
        document.getElementById("apr_avg").innerHTML = avg_apr;
        document.getElementById("saving_avg").innerHTML = avg_saving;
        document.getElementById("monthly_payment_avg").innerHTML = avg_monthly_payment;
        document.getElementById("closing_cost_avg").innerHTML = avg_closing_cost;
    }

   // $('#adv-option').click(function () {
   //      $("html, body").animate({
   //          scrollTop: 250
   //      }, 1000);
   //      //return false;
   //  });
   

   $('#adv_loan_purpose').change(function () {
      $('#loan_purpose').val($('#adv_loan_purpose').val())
    });

   $('#loan_purpose').change(function () {
      $('#adv_loan_purpose').val($('#loan_purpose').val())
    });

    if (location.href.includes("refinance")) {
      $('#loan_purpose').val('Refinance');
      $('#adv_loan_purpose').val('Refinance');
    }

   // $('.favorite').click(function () {
   //    program_id = this.id
   //    $.ajax({
   //      url: '/pages/favorite_program',
   //      type: "GET",
   //      data: {program_id: program_id},
   //      success: function(response) {
   //        // $(".loader").hide();
   //      }
   //    });
   //  });
  });
