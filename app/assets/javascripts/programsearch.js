function get_form_submitted(flag){
  if (flag) {
    get_program_results();
  }
}

function get_program_results(){
  $(".suitable-program").hide()
  $(".loader").show();
  var data = $("#search_form").serialize();
  $('.rates-tab li.active').removeClass('active');
  if ($('.term_30').prop('checked')) {
    data = data+'&term=30&loan_type=Fixed'
    $('.li-30years').addClass("active");
  }else{
    if ($('.term_15').prop('checked')) {
      data = data+'&term=15&loan_type=Fixed'
      $('.li-15years').addClass("active");
    }else{
      if ($('.term_10').prop('checked')) {
        data = data+'&term=10&loan_type=Fixed'
        $('.li-10years').addClass("active");
      }else{
        if ($('.arm_basic_7').prop('checked')) {
          data = data+'&arm_basic=7/1&loan_type=ARM'
          $('.li-71years').addClass("active");
        }else{
          if ($('.arm_basic_5').prop('checked')) {
            data = data+'&arm_basic=5/1&loan_type=ARM'
            $('.li-51years').addClass("active");
          }
        }
      }
    }
  }

  data = data+'&commit=commit'
  $.ajax({
    url: '/',
    type: "GET",
    dataType: "script",
    data: data,
    success: function(response) {
      $(".suitable-program").show()
      setTimeout(function(){
       $('#loadMore').show();
       $(".loader").hide(); 
      }, 2000);
      tab_val = $('.active .js-trigger').attr('data-tab') == "5" ? "51" : $('.active .js-trigger').attr('data-tab')
      load_more(tab_val, true);
    }
  });
}

function load_more(tab_val, flag){
    size_li = $("#"+tab_val+"years .demo-items-"+tab_val).length;
    // $("."+tab_val+"years").addClass('active')
    $("#"+tab_val+"years .demo-items-"+tab_val).hide();
      if (!flag) {
        x = (x+20 <= size_li) ? x+20 : size_li;
        $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")").show();
        average_closing_cost(tab_val,x)
      }else{
        if (seo_link.includes('/mortgage/') ||seo_link.includes('/mortgage/') ) {
          x = 10
        }else{
          x = 20
        }
        $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")").show();
        average_closing_cost(tab_val,x)
      }
      if(x == size_li || size_li < 20){
        $('#loadMore').hide();
      }
  }

  function average_closing_cost(tab_val,x){
    var size_li2 = $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")")
    var air_total = 0
    var apr_total = 0
    var saving_total = 0
    var monthly_payment_total = 0
    var closing_cost_total = 0
    for (i = 0; i < size_li2.length; i++) { 
      air = size_li2[i].querySelector('.a_air').textContent.trim().split('%')[0];
      apr = size_li2[i].querySelector('.a_apr').textContent.trim().split('%')[0];
      saving = size_li2[i].querySelector('.a_saving').textContent.trim().replace(/[$\,]/g,"")
      monthly_payment = size_li2[i].querySelector('.a_monthly_payment').textContent.trim().replace(/\,/g,"").split('$')[1];
      closing_cost = size_li2[i].querySelector('.a_closing_cost').textContent.trim().replace(/\,/g,"").split('$')[1];
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
      avg_air = (air_total/size_li2.length).toFixed(3)+"%"
      avg_apr = (apr_total/size_li2.length).toFixed(3)+"%"
      avg_saving = (saving_total/size_li2.length)
      avg_saving = "$"+formatMoney(avg_saving)
      avg_monthly_payment = (monthly_payment_total/size_li2.length)
      avg_monthly_payment = "$"+formatMoney(avg_monthly_payment)
      avg_closing_cost = (closing_cost_total/size_li2.length)
      avg_closing_cost = "$"+formatMoney(avg_closing_cost)
      
      document.getElementById("air_avg").innerHTML = avg_air;
      document.getElementById("apr_avg").innerHTML = avg_apr;
      document.getElementById("saving_avg").innerHTML = avg_saving;
      document.getElementById("monthly_payment_avg").innerHTML = avg_monthly_payment;
      document.getElementById("closing_cost_avg").innerHTML = avg_closing_cost;
  }

  function formatMoney(amount, decimalCount = 2, decimal = ".", thousands = ",") {
    try {
      decimalCount = Math.abs(decimalCount);
      decimalCount = isNaN(decimalCount) ? 2 : decimalCount;
      const negativeSign = amount < 0 ? "-" : "";
      let i = parseInt(amount = Math.abs(Number(amount) || 0).toFixed(decimalCount)).toString();
      let j = (i.length > 3) ? i.length % 3 : 0;
      // return negativeSign + (j ? i.substr(0, j) + thousands : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands) + (decimalCount ? decimal + Math.abs(amount - i).toFixed(decimalCount).slice(2) : "");
      return negativeSign + (j ? i.substr(0, j) + thousands : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands)
    } catch (e) {
      console.log(e)
    }
  };

$(document).ready(function () {
    seo_link = $(location).attr("href");
    var tab_val = $('.active .js-trigger').attr('data-tab');
    var size_li = 0
    let x = 20
    if (seo_link.includes('/mortgage/') ||seo_link.includes('/mortgage/') ) {
      x = 10
    }
    load_more(tab_val, true);
    average_closing_cost(tab_val,20)
    $('.tab-btn').click(function (e) {
      tab_val = $(this).text().replace ( /[^\d.]/g, '' );
      // load_m`ore(tab_val);
    });

    tab_term =  $('.active .js-trigger').attr('data-tab')
    $('.js-trigger').click(function(){
      $(".loader").show();  
      $('.rates-tab li.active').removeClass('active');
      tab_val = $(this).attr('data-tab');
      $('.li-'+tab_val+'years').addClass("active");
       var data = $("#search_form").serialize();
        
          if (tab_val=="30") {
            data = data+'&term=30&loan_type=Fixed&ajax_call=true'
            $('.li-30years').addClass("active");
          }else{
            if (tab_val=="15") {
              data = data+'&term=15&loan_type=Fixed&ajax_call=true'
              $('.li-15years').addClass("active");
            }else{
              if (tab_val=="10") {
                data = data+'&term=10&loan_type=Fixed&ajax_call=true'
                $('.li-10years').addClass("active");
              }else{
                if (tab_val=="71") {
                  data = data+'&arm_basic=7/1&loan_type=ARM&ajax_call=true'
                  $('.li-71years').addClass("active");
                }else{
                  if (tab_val=="51") {
                    data = data+'&arm_basic=5/1&loan_type=ARM&ajax_call=true'
                    $('.li-51years').addClass("active");
                  }
                }
              }
            }
          }

      data = data+'&commit=commit'
      $.ajax({
        url: '/',
        type: "GET",
        dataType: "script",
        data: data,
        success: function(response) {
          $(".loader").hide();
          tab_val = $('.active .js-trigger').attr('data-tab') == "5" ? "51" : $('.active .js-trigger').attr('data-tab')
          $('#loadMore').show();
          load_more(tab_val, true);
        }
      });
    });

    $('.menu-up-adv-search').click(function(){
      $("#search-adv-option-inner").hide("fast").removeClass("display-adv-search");
    });
  
      $('.state').change(function(){
          var id_passed = $(".state option:selected").val();
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
          var id_passed = $(".city option:selected").val();
          var state = $(".state option:selected").val();
          $.ajax({
              url: '/pages/expert_city_and_zip',
              type: "GET",
              dataType: 'json',
              data: {"city" : id_passed, "state": state},
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
            required: true,
            minlength: 10,
            maxlength: 15
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
          "expert[specialty]":{
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
            required: "Plese enter mobile number.",
            minlength: "Phone number should be 10-15 digits.",
            maxlength: "Phone number should be 10-15 digits."
          },
          "expert[email]": {
              required: "Please enter your email.",
              email: "Please enter valid email address.",
          },
          "expert[state]":{
              required: "Please select a state"
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
          "expert[specialty]":{
            required: "Please enter specialty."
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
    
      var selected_tabs = []
      if($('.arm_basic_5').prop('checked')){
        selected_tabs.push(51)
      }
      if($('.arm_basic_7').prop('checked')){
        selected_tabs.push(71)
      }
      if($('.term_30').prop('checked')){
        selected_tabs.push(30)
      }
      if($('.term_15').prop('checked')){
        selected_tabs.push(15)
      }
      if($('.term_10').prop('checked')){
        selected_tabs.push(10)
      }
      dynamic_tab();

      $('.arm_basic_5').click(function () {
        if ($(this).prop("checked")){
          selected_tabs.push(51);
        }else{
          if (selected_tabs.length>1) {
            var index = selected_tabs.indexOf(51);
            if (index > -1) {
              selected_tabs.splice(index, 1);
            }
          }else{
            $(this).prop('checked', true);
          }
        }
        dynamic_tab();
      });
      $('.arm_basic_7').click(function () {
        if ($(this).prop("checked")){
          selected_tabs.push(71);
        }else{
          if (selected_tabs.length>1) {
            var index = selected_tabs.indexOf(71);
            if (index > -1) {
              selected_tabs.splice(index, 1);
            }
          }else{
            $(this).prop('checked', true);
          }
        }
        dynamic_tab();
      });
      $('.term_30').click(function () {
        if ($(this).prop("checked")){
          selected_tabs.push(30);
        }else{
          if (selected_tabs.length>1) {
            var index = selected_tabs.indexOf(30);
            if (index > -1) {
              selected_tabs.splice(index, 1);
            }
          }else{
            $(this).prop('checked', true);
          }
        }
        dynamic_tab();
      });
      $('.term_15').click(function () {
        if ($(this).prop("checked")){
          selected_tabs.push(15);
        }else{
          if (selected_tabs.length>1) {
            var index = selected_tabs.indexOf(15);
            if (index > -1) {
              selected_tabs.splice(index, 1);
            }
          }else{
            $(this).prop('checked', true);
          }
        }
        dynamic_tab();
      });
      $('.term_10').click(function () {
        if ($(this).prop("checked")){
          selected_tabs.push(10);
        }else{
          if (selected_tabs.length>1) {
            var index = selected_tabs.indexOf(10);
            if (index > -1) {
              selected_tabs.splice(index, 1);
            }
          }else{
            $(this).prop('checked', true);
          }
        }
        dynamic_tab();
      });
      
    function dynamic_tab(){
      if (selected_tabs.includes(30)) {
        $('.li-30years').show()
      }else{
        $('.li-30years').hide()
      }

      if (selected_tabs.includes(15)) {
        $('.li-15years').show()
      }else{
        $('.li-15years').hide()
      }

      if (selected_tabs.includes(10)) {
        $('.li-10years').show()
      }else{
        $('.li-10years').hide()
      }

      if (selected_tabs.includes(71)) {
        $('.li-71years').show()
      }else{
        $('.li-71years').hide()
      }

      if (selected_tabs.includes(51)) {
        $('.li-51years').show()
      }else{
        $('.li-51years').hide()
      }
    }
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

      $('#loadMore').click(function () {
        tab_val = tab_val = $('.active .js-trigger').attr('data-tab') == "5" ? "51" : $('.active .js-trigger').attr('data-tab')
        load_more(tab_val, false);
      });

    
    

   $('.mb-adv-search').click(function () {
        $("html, body").animate({
            scrollTop: 300
        }, 1000);
        //return false;
    });
   

   $('#adv_loan_purpose').change(function () {
      $('#loan_purpose').val($('#adv_loan_purpose').val())
    });

   $('#loan_purpose').change(function () {
      $('#adv_loan_purpose').val($('#loan_purpose').val())
    });
  });