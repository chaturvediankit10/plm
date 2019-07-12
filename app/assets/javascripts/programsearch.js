$(document).ready(function () {
    var tab_val = $('.active .js-trigger').attr('data-tab');
    load_more(tab_val);
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

      $('#bank_name').change(function(){
        var bank_name =  $(this).val();
        var loan_category = "All"
        var pro_category = "All"

        $.ajax({
          type:'GET',
          url:'/fetch_programs',
          data: {bank_name : bank_name, loan_category: loan_category, pro_category: pro_category },
          success:function(response){
            var selectBox = document.getElementById('program_name');
            selectBox.options.length = 0
            selectBox.options.add( new Option('All', 'All'));
            response.program_list.map((program)=>{
              selectBox.options.add( new Option(program.name, program.name));
            });
            var selectBox2 = document.getElementById('loan_category');
            selectBox2.options.length = 0
            selectBox2.options.add( new Option('All', 'All'));
            response.loan_category_list.map((loan_category)=>{
              selectBox2.options.add( new Option(loan_category.name, loan_category.name));
            });
            var selectBox3 = document.getElementById('pro_category');
            selectBox3.options.length = 0
            response.pro_category_list.map((pro_category)=>{
              selectBox3.options.add( new Option(pro_category.name, pro_category.name));
            });

          }
        });
      });

      $('#loan_category').change(function(){
        var loan_category =  $(this).val();
        var bank_name = $('#bank_name').val()
        var pro_category ="All"
        $.ajax({
          type:'GET',
          url:'/fetch_programs',
          data: {loan_category : loan_category, bank_name : bank_name, pro_category: pro_category },
          success:function(response){
            var selectBox = document.getElementById('program_name');
            selectBox.options.length = 0
            selectBox.options.add( new Option('All', 'All'));
            response.program_list.map((program)=>{
              selectBox.options.add( new Option(program.name, program.name));
            });

            var selectBox2 = document.getElementById('pro_category');
            selectBox2.options.length = 0
            response.pro_category_list.map((pro_category)=>{
              selectBox2.options.add( new Option(pro_category.name, pro_category.name));
            });
          }
        });
      });

      $('#pro_category').change(function(){
        var pro_category =  $(this).val();
        var bank_name = $('#bank_name').val()
        var loan_category = $('#loan_category').val()
        $.ajax({
          type:'GET',
          url:'/fetch_programs',
          data: {loan_category : loan_category, bank_name : bank_name, pro_category: pro_category },
          success:function(response){
            var selectBox = document.getElementById('program_name');
            selectBox.options.length = 0
            selectBox.options.add( new Option('All', 'All'));
            response.program_list.map((program)=>{
              selectBox.options.add( new Option(program.name, program.name));
            });
          }
        });
      });

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
        $("#"+tab_val+"years .demo-items-"+tab_val+":lt("+x.toString()+")").show();
      });
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
