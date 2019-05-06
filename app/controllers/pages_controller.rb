=begin
  Developer:      Varun
  Created:        16-03-2018
  Purpose:        Following actions are for status update in admin panel .
=end
class PagesController < ApplicationController
  include Dashboard
  before_action :authenticate_user!, only: [:secret]
  before_action :update_statue, only: [:change_status, :user_mass_activate, :user_mass_deactivate]
  before_action :set_default, :except => [:show, :refinance, :mortgage, :calculation, :contact_us_email, :research_contact_us_email, :research_post, :update_profile, :change_status, :user_mass_activate, :user_mass_deactivate, :expert_user_registration, :expert_state_and_city, :expert_city_and_zip, :city_freddie_cache_data]

  def index
    @banks = Bank.all
    @all_banks_name = @banks.pluck(:name)
    if params["commit"].present?
     set_variable
     find_base_rate
   else
    set_default_values_without_submition
    find_base_rate
   end
    fetch_programs_by_bank(true)
  end

  def fetch_programs_by_bank(html_type=false)
    @all_programs = Program.all
    @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
    @loan_categories = @all_programs.pluck(:loan_category).uniq.compact.sort
    @program_categories = @all_programs.pluck(:program_category).uniq.compact.sort

    if params[:bank_name].present?
      if (params[:bank_name] == "All")
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
        @loan_categories = @all_programs.pluck(:loan_category).uniq.compact.sort
        @program_categories = @all_programs.pluck(:program_category).uniq.compact.sort
      else
        @all_programs = @all_programs.where(bank_name: params[:bank_name])
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
        @loan_categories = @all_programs.pluck(:loan_category).uniq.compact.sort
        @program_categories = @all_programs.pluck(:program_category).uniq.compact.sort
      end
    end
    if params[:loan_category].present?
      if (params[:loan_category] == "All")
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
        @program_categories = @all_programs.pluck(:program_category).uniq.compact.sort
      else
        @all_programs = @all_programs.where(loan_category: params[:loan_category])
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
        @program_categories = @all_programs.pluck(:program_category).uniq.compact.sort
      end
    end
    if params[:pro_category].present?
      if (params[:pro_category] == "All" || params[:pro_category] == "No Category")
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
      else
        @all_programs = @all_programs.where(program_category: params[:pro_category])
        @program_names = @all_programs.pluck(:program_name).uniq.compact.sort
      end
    end

    if @program_categories.present?
      @program_categories.prepend(["All"])
    else
      @program_categories << "No Category"
    end
    render json: {program_list: @program_names.map{ |lc| {name: lc}}, loan_category_list: @loan_categories.map{ |lc| {name: lc}}, pro_category_list: @program_categories.map{ |lc| {name: lc}}} unless html_type
  end

  def set_default
    @term_list = (Program.pluck(:term).reject(&:blank?).uniq.map{|n| n if n.to_s.length < 3}.reject(&:blank?).push(5,10,15,20,25,30).uniq.sort).map{|y| [y.to_s + " yrs" , y]}.prepend(["All"])
    @arm_advanced_list = Program.pluck(:arm_advanced).push("3-2-5").uniq.compact.reject { |c| c.empty? }.map{|c| [c]}
    @base_rate = 0.0
    @filter_data = {}
    @filter_not_nil = {}
    @interest = "4.000"
    @term = "30"
    @ltv = []
    @cltv = []
    @credit_score = []
    @flag_loan_type = false
    @lock_period ="30"
    @loan_size = "High-Balance"
    @loan_type = "Fixed"
    @fannie_mae_product = "HomeReady"
    @freddie_mac_product = "Home Possible"
    @arm_basic = "5/1"
    @arm_advanced = "1-1-5"
    @program_category = "6900"
    @property_type = "1 Unit"
    @financing_type = "Subordinate Financing"
    @premium_type ="1 Unit"
    @refinance_option ="Cash Out"
    @misc_adjuster = "CA Escrow Waiver (Full or Taxes Only)"
    @state = "All"
    @result = []
    @loan_amount = "0 - 50000"
    @ltv1 = "65.01 - 70.00"
    @credit_score1 = "700-719"
    @dti = "25.6%"
    @loan_purpose = "Purchase"
    @home_price = "300000"
    @down_payment = "50000"
    @coverage = "30.5%"
    @margin = "2.0"
    ltv_range = ("65.01-70.00".split("-").first.to_f.."65.01-70.00".split("-").last.to_f) rescue nil
    array_data = []
    ltv_range.step(0.01) { |f| array_data << f } rescue nil
    @ltv = array_data.try(:uniq)

    cltv_range = ("75.01-80.00".split("-").first.to_f.."75.01-80.00".split("-").last.to_f) rescue nil
    array_data = []
    cltv_range.step(0.01) { |f| array_data << f } rescue nil
    @ltv = array_data.try(:uniq)

    credit_score = ("700-719".split("-").first.to_f.."700-719".split("-").last.to_f) rescue nil
    array_data = []
    credit_score.step(0.01) { |f| array_data << f } rescue nil
    @credit_score = array_data.try(:uniq)
  end

  def modified_ltv_cltv_credit_score
    %w[ltv cltv credit_score].each do |key|
      array_data = []
      if key == "ltv" || key == "cltv"
        key_value = params[key.to_sym]
        if key_value.present?
          if key_value.include?("-")
            key_range = (key_value.split("-").first.to_f..key_value.split("-").last.to_f)
            key_range.step(0.01) { |f| array_data << f }
            instance_variable_set("@#{key}", array_data.try(:uniq))
          else
            instance_variable_set("@#{key}", key_value)
          end
        end
      end
      if key == "credit_score"
        key_value = params[key.to_sym]
        if key_value.present?
          if key_value.include?("-")
            array_data = (key_value.split("-").first.to_i..key_value.split("-").last.to_i)
            instance_variable_set("@#{key}", array_data.try(:uniq))
          else
            instance_variable_set("@#{key}", key_value)
          end
        end
      end
    end
  end

  def modified_condition
    %w[fannie_mae_product freddie_mac_product bank_name program_name pro_category loan_category loan_purpose].each do |key|
      key_value = params[key.to_sym]
      if key_value.present?
        unless (key_value == "All")
          if (key == "pro_category")
            unless (key_value == "No Category")
              @filter_data[:program_category] = key_value
            end
          else
            if (key == "program_name")
              @filter_data[key.to_sym] = key_value.remove("\r")
            else
              @filter_data[key.to_sym] = key_value
            end
          end
          if %w[fannie_mae_product freddie_mac_product pro_category loan_category loan_purpose].include?(key)
            instance_variable_set("@#{key}", key_value)
          end
        else
          if %w[fannie_mae_product freddie_mac_product loan_purpose].include?(key)
            @filter_not_nil[key.to_sym] = nil
          end
        end
      end
    end
  end

  def modified_true_condition
    %w[fannie_mae freddie_mac du lp fha va usda streamline full_doc].each do |key|
      key_value = params[key.to_sym]
      if key_value.present?
        @filter_data[key.to_sym] = true
      end
    end
  end

  def modified_variables
    %w[state property_type financing_type refinance_option refinance_option misc_adjuster premium_type interest lock_period loan_amount program_category payment_type dti].each do |key|
      key_value = params[key.to_sym]
      instance_variable_set("@#{key}", key_value) if key_value.present?
    end
  end

  def set_term
    if params[:term].present?
      if (params[:term] == "All")
        @filter_not_nil[:term] = nil
      else
        @filter_data[:term] = params[:term].to_i
        @term = params[:term]
        @program_term = params[:term].to_i
      end
    end
  end

  def set_arm_basic
    if params[:arm_basic].present?
      if (params[:arm_basic] == "All")
        @filter_not_nil[:arm_basic] = nil
      else
        if params[:arm_basic].include?("/")
          @filter_data[:arm_basic] = params[:arm_basic].split("/").first
          @arm_basic = params[:arm_basic]
        end
      end
    end
  end

  def set_arm_advanced
    if params[:arm_advanced].present?
      if params[:arm_advanced] == "All"
        @filter_not_nil[:arm_advanced] = nil
      else
        @arm_advanced = params[:arm_advanced]
        @filter_data[:arm_advanced] = params[:arm_advanced]
      end
    end
  end

  def set_arm_benchmark
    if params[:arm_benchmark].present?
      if params[:arm_benchmark] == "All"
        @filter_not_nil[:arm_benchmark] = nil
      else
        @arm_benchmark = params[:arm_benchmark]
        @filter_data[:arm_benchmark] = params[:arm_benchmark]
      end
    end
  end

  def set_arm_margin
    if params[:arm_margin].present?
      if params[:arm_margin] == "All"
        @filter_not_nil[:arm_margin] = nil
      else
        @arm_margin = params[:arm_margin].to_f
        @filter_data[:arm_margin] = params[:arm_margin].to_f
      end
    end
  end

  def set_default_values_without_submition
    @filter_not_nil[:term] = nil
    @filter_not_nil[:arm_basic] = nil
    @filter_not_nil[:arm_advanced] = nil
    @filter_not_nil[:arm_benchmark] = nil
    @filter_not_nil[:arm_margin] = nil
    set_flag_loan_type(true)
  end
  def set_flag_loan_type(flag)
    @flag_loan_type = flag
  end

  def set_variable
    modified_ltv_cltv_credit_score
    modified_condition
    modified_true_condition
    modified_variables
    if params[:loan_type].present?
      @loan_type = params[:loan_type]
      if params[:loan_type] == "All"
        @filter_not_nil[:loan_type] = nil
        set_flag_loan_type(true)
        set_term
        set_arm_basic
        set_arm_advanced
        set_arm_benchmark
        set_arm_margin
      else
        @filter_data[:loan_type] = params[:loan_type]
        if params[:loan_type] =="ARM"
          set_flag_loan_type(false)
          set_arm_basic
          set_arm_advanced
          set_arm_benchmark
          set_arm_margin
        end
        if params[:loan_type] !="ARM"
          set_term
        end
      end
    else
      set_flag_loan_type(true)
    end

    if params[:loan_size].present?
      if params[:loan_size] == "All"
        @filter_not_nil[:loan_size] = nil
      end
    end
    @credit_score1 = params[:credit_score].present? ? params[:credit_score] : ""
    @ltv1 = params[:ltv].present? ? params[:ltv] : ""
    @home_price = params[:home_price].present? ? params[:home_price].tr(',', '') : "300000"
    @down_payment = params[:down_payment].present? ? params[:down_payment].tr(',', '') : "50000"
  end

  def find_programs_on_term_based(programs, find_term)
    program_list = []
    programs.each do |program|
       pro_term = program.term
      if (pro_term.to_s.length <=2 )
        if (pro_term == find_term)
          program_list << program
        end
      else
        first = pro_term/100
        last = pro_term%100
        term_arr = []
        if first < last
          term_arr = (first..last).to_a
        else
          term_arr = (last..first).to_a
        end
        if term_arr.include?(find_term)
          program_list << program
        end
      end
    end
    return program_list
  end

  def calculate_base_rate_of_selected_programs(programs)
    program_list = []
    programs.each do |program|
      if program.base_rate.present?
        base_rate_keys = program.base_rate.keys.map{ |k| ActionController::Base.helpers.number_with_precision(k, :precision => 3)}

        interest_rate = ActionController::Base.helpers.number_with_precision(@interest.to_f.to_s, :precision => 3)

        key_list = program.base_rate.keys

        if(base_rate_keys.include?(interest_rate))
          rate_index = base_rate_keys.index(interest_rate)
          if(program.base_rate[key_list[rate_index]].keys.include?(@lock_period))
              program_list << program
          end
        end
      end
    end
    return program_list
  end

  def search_programs_with_loan_type_all
    term_programs = []
    arm_programs = []
    if (@filter_not_nil.keys & [:arm_basic, :arm_advanced, :arm_margin, :arm_benchmark, :term]).any?
        term_programs = Program.where.not(loan_type: "ARM")
        arm_programs1 = Program.where(loan_type: "ARM")
        arm_basic_programs  = []
        arm_advanced_programs = []
        arm_margin_programs = []
        arm_benchmark_programs  = []
        if (@filter_not_nil.keys.include?(:arm_basic))
          arm_basic_programs = arm_programs1.where.not(arm_basic: nil)
        end
        if (@filter_not_nil.keys.include?(:arm_advanced))
          arm_advanced_programs = arm_programs1.where.not(arm_advanced: nil)
        end
        if (@filter_not_nil.keys.include?(:arm_margin))
          arm_margin_programs = arm_programs1.where.not(arm_margin: nil)
        end
        if (@filter_not_nil.keys.include?(:arm_benchmark))
          arm_benchmark_programs = arm_programs1.where.not(arm_benchmark: nil)
        end
      arm_programs = (arm_basic_programs + arm_advanced_programs + arm_margin_programs + arm_benchmark_programs).uniq
    else
      if (@filter_not_nil.keys.include?(:term))
        term_programs = Program.where.not(loan_type: "ARM")
      else
        if (@filter_not_nil.keys.include?(:arm_basic || :arm_advanced || :arm_margin || :arm_benchmark))
          arm_programs = Program.where(loan_type: "ARM")
        else
          term_programs = Program.where.not(loan_type: "ARM")
          arm_programs = Program.where(loan_type: "ARM")
        end
      end
    end

    if (@filter_data.keys & [:term] & [:arm_basic, :arm_advanced, :arm_margin, :arm_benchmark, :term]).any?
        term_programs1 = Program.where(@filter_data.except(:arm_basic, :arm_advanced, :arm_benchmark, :arm_margin, :term))
        term_programs = find_programs_on_term_based(term_programs1, @filter_data[:term])
        arm_programs = Program.where(@filter_data.except(:term))
    else
      if (@filter_data.keys & [:term]).any?
        term_programs1 = Program.where(@filter_data.except(:arm_basic, :arm_advanced, :arm_benchmark, :arm_margin, :term))
        term_programs = find_programs_on_term_based(term_programs1, @filter_data[:term])
      else
        if (@filter_data.keys & [:arm_basic, :arm_advanced, :arm_margin, :arm_benchmark]).any?
          arm_programs = Program.where(@filter_data.except(:term))
        end
      end
    end
    if arm_programs.present?
      arm_ids = arm_programs.pluck(:id)
      arm_programs = Program.where(id: arm_ids).where(@filter_data.except(:term))
    end
    if term_programs.present?
      term_ids = term_programs.pluck(:id)
      term_programs = Program.where(id: term_ids).where(@filter_data.except(:arm_basic, :arm_advanced, :arm_benchmark, :arm_margin, :term))
    end
    
    total_searched_program1 = calculate_base_rate_of_selected_programs((term_programs + arm_programs).uniq)
      total_searched_program = []

      if total_searched_program1.present?
        if params[:loan_size].present?
          if params[:loan_size] == "All"
            total_searched_program = total_searched_program1
          else
            @loan_size = params[:loan_size]
            total_searched_program1 = total_searched_program1.map{ |pro| pro if pro.loan_size!=nil}.compact
            total_searched_program1.each do |pro|
              if(pro.loan_size.split("&").map{ |l| l.strip }.include?(params[:loan_size]))
                total_searched_program << pro
              end
            end
          end
        else
          total_searched_program = total_searched_program1
        end
      end

    @result= []
    if total_searched_program.present?
      @result = find_adjustments_by_searched_programs((params["commit"].present? ? total_searched_program : Program.all), @lock_period, @arm_basic, @arm_advanced, @fannie_mae_product, @freddie_mac_product, @loan_purpose, @program_category, @property_type, @financing_type, @premium_type, @refinance_option, @misc_adjuster, @state, @loan_type, @loan_size, @result, @interest, @loan_amount, @ltv, @cltv, @term, @credit_score, @dti )
    end
  end

  def search_programs_with_selected_loan_type
    @program_list = Program.where(@filter_data.except(:term))
    @program_list = @program_list.where.not(@filter_not_nil)
    @program_list2 = []
    if @program_list.present?
      if @program_term.present?
        @program_list = @program_list.where.not(term:nil)
        @program_list2 = find_programs_on_term_based(@program_list, @program_term)
      else
        @program_list2 = @program_list
      end

      if @program_list2.present?
        @program_list3 = []
        if params[:loan_size].present?
          if params[:loan_size] == "All"
            @program_list3 = @program_list2
          else
            @loan_size = params[:loan_size]
            @program_list2 = @program_list2.map{ |pro| pro if pro.loan_size!=nil}.compact
            @program_list2.each do |pro|
              if(pro.loan_size.split("and").map{ |l| l.strip }.include?(params[:loan_size]))
                @program_list3 << pro
              end
            end
          end
        else
          @program_list3 = @program_list2
        end
      end

      @programs =[]
      if @program_list3.present?
        @programs = calculate_base_rate_of_selected_programs(@program_list3)
      end
      @result= []
      if @programs.present?
        @result = find_adjustments_by_searched_programs((params["commit"].present? ? @programs : Program.all), @lock_period, @arm_basic, @arm_advanced, @fannie_mae_product, @freddie_mac_product, @loan_purpose, @program_category, @property_type, @financing_type, @premium_type, @refinance_option, @misc_adjuster, @state, @loan_type, @loan_size, @result, @interest, @loan_amount, @ltv, @cltv, @term, @credit_score, @dti )
      end
    end
  end

  def find_base_rate
    if (@flag_loan_type)
      search_programs_with_loan_type_all
    else
      search_programs_with_selected_loan_type
    end
  end

  def show
    page = CmsPage.find_by(page_slug: params[:page_slug])
    if page
      @page = page
    else
       content_not_found  
    end
  end

  def refinance

  end

  def mortgage

  end  
    
  def calculation
    if params[:amt].present?
      if params[:amt].present? && params[:amt].to_i > 0
        @p_amt = params[:amt].to_f
        @additional_points = 0.0

        if params[:lock_period] == "15 days" && params[:rate] == "5.125"
          @additional_points =  3.602
        elsif params[:lock_period] == "15 days" && params[:rate] == "5.000" 
          @additional_points = 3.253
        elsif params[:lock_period] == "30 days" && params[:rate] == "5.125" 
          @additional_points = 3.502 
        elsif params[:lock_period] == "30 days" && params[:rate] == "5.000" 
         @additional_points = 3.153
        end 
           
        if params[:cs] == ">= 740" && params[:ltv] == '80 <= 85'
          @additional_points = @additional_points - 0.250
        elsif params[:cs] == ">= 740" && params[:ltv] == '>85 <= 90'
          @additional_points = @additional_points - 0.250
        elsif params[:cs] == '720 & <= 739' && params[:ltv] == '80 <= 85'
          @additional_points = @additional_points - 0.500
        elsif params[:cs] == '720 & <= 739' && params[:ltv] == '>85 <= 90'              
          @additional_points = @additional_points - 0.500
        end
        @p_amt = (@p_amt * @additional_points / 100) + @p_amt
        @p_amt -= 795 # Conventional Conforming Wholesale Fee 
        years = params[:time_period] == '30 years' ?  30 : 20
        months = 12 * years
        rate = params[:rate].to_f / 100
        rate = rate / 12
        @final_amt_per_month = @p_amt * rate * ((1 + rate)**months) / ((1 + rate)**months - 1)
        @rate = params[:rate]
        @amt = params[:amt].to_f
        @cs = params[:cs]
        @ltv = params[:ltv]
        @total = @final_amt_per_month * months
        @interest_amt = @total - @amt  
      else
        flash[:danger] = 'You entered wrong value.'
        redirect_to calculation_path  
      end
    end
  end

  # for sending emails from different different modules starts from here
  def contact_us_email
    @admin_user = AdminUser.first.email
    #ContactUsMailer.contact_us_email(@admin_user,params).deliver
    receivers  = ["ray@relativityteam.com", "tzewee@relativityteam.com", @admin_user]
      receivers.each do |rec|
        ContactUsMailer.contact_us_email(rec,params).deliver
      end
    flash[:notice] = 'Email sent successfully.'
    redirect_back fallback_location: root_path
	end

  def research_contact_us_email
    @admin_user = AdminUser.first.email
     receivers  = ["ray@relativityteam.com", "tzewee@relativityteam.com", @admin_user]
      receivers.each do |rec|
        if !params[:attachment].nil? && !params[:attachment].blank?
          file = params[:attachment].tempfile.path
          file_name = params[:attachment].original_filename
        else
          file = ""
          file_name = ""
        end           
        ResearchMailer.research_email(rec, params[:name], params[:email], params[:website], params[:message],file_name,file).deliver
      end
    flash[:notice] = 'Research submitted successfully.'
    redirect_back fallback_location: root_path
  end

  def research_post
    @admin_user = AdminUser.first.email
    if !params[:attachment].nil? && !params[:attachment].blank?
      file = params[:attachment].tempfile.path
      file_name = params[:attachment].original_filename
    else
      file = ""
      file_name = ""
    end           
    ResearchPostMailer.research_post_email(@admin_user, params[:name], params[:email], params[:phone_no], params[:research_summary],file_name,file, params[:title]).deliver

    flash[:notice] = 'Research posted successfully.'
    redirect_back fallback_location: root_path
  end
  # for sending emails from different different modules ends here
  
  #For update user details from admin panel starts from here
  def update_profile
    @user = User.find_by(id: params[:user][:id])
    @user.update_attributes(user_params)
    begin
     @user.save!
      flash[:notice]= 'Your account has been updated successfully.'
    rescue => e 
      flash[:danger]= "Your account has not updated because '#{e.message}'."
    end
      redirect_to edit_user_registration_path
  end

  def change_status
    @user.each do |usr|
      usr.update_attributes(is_active: !usr.is_active)
    end
    redirect_to admin_root_path, notice: "User #{@user.first.is_active ? "Activated" : "Dectivated"} Succesfully."
  end

  def user_mass_activate
    @user.each do |usr|
      usr.update(is_active: true)
     end
    redirect_to admin_root_path, notice: 'Selected Users Activated Succesfully.'
  end

  def user_mass_deactivate
    @user.each do |usr|
      usr.update(is_active: false)
     end
    redirect_to admin_root_path, notice: 'Selected Users Deactivated Succesfully.'
  end
  #For update user details from admin panel ends here
  
  def expert_user_registration
      @expert_user = Expert.new expert_params
      city_zip = params[:expert][:city].split(',')
      @expert_user.city = city_zip[0]
      @expert_user.zip = city_zip[1]
      begin
        @expert_user.save!
        flash[:notice] = 'You are succesfully registered as expert.'
      rescue => e
        flash[:danger] = "Your account has not created." 
      end
      redirect_back fallback_location: root_path
  end

  def expert_state_and_city
    if request.xhr?
     # city = City.where(state_code: params[:state]).uniq(&:city).sort_by(&:city).pluck(:city,:zip)
     city = City.where(state_code: params[:state]).uniq(&:city).sort_by(&:city).pluck(:city)
     render json: city
    end
  end

  def expert_city_and_zip
    if request.xhr?
     # city = City.where(state_code: params[:state]).uniq(&:city).sort_by(&:city).pluck(:city,:zip)
     zip = City.where(city: params[:city]).sort_by(&:zip).pluck(:zip)
     render json: zip
    end
  end 

  #Calling all the background workers for creating dynamic reports for city pages
  def city_freddie_cache_data
    FreddieMacCacheWorker.perform_async(["AK", "AL", "AR", "AZ", "CA", "CO"])
    FreddieMacCacheAWorker.perform_async(["CT", "DC", "DE", "FL", "GA", "HI"])
    FreddieMacCacheBWorker.perform_async(["IA", "ID", "IL", "IN", "KS"])
    FreddieMacCacheCWorker.perform_async(["KY", "LA", "MA", "MD", "ME"])
    FreddieMacCacheDWorker.perform_async(["MI", "MN", "MO", "MS", "MT"])
    FreddieMacCacheEWorker.perform_async(["NC", "ND", "NE", "NH", "NJ"])
    FreddieMacCacheFWorker.perform_async(["NM", "NV", "NY", "OH", "OK"])
    FreddieMacCacheGWorker.perform_async(["OR", "PA", "PR", "RI", "SC"])
    FreddieMacCacheHWorker.perform_async(["SD", "TN", "TX", "UT", "VA"])
    FreddieMacCacheIWorker.perform_async(["VT", "WA", "WI", "WV", "WY"])
    redirect_to admin_freddie_mac_caches_path, notice: 'Data Cache start for Cities.'  
  end   

  private
    def update_statue
      all_ids = params[:id].reject{|a| a.blank?}
      @user = User.find(all_ids)
    end  
    
    def user_params
        params.require(:user).permit(:id,:first_name,:last_name,:email,:phone_number,:zip_code,:purpose, :home_price, :down_payment, :credit_score,:password, :password_confirmation, :current_password,:price_alert)
    end

    def expert_params
      params.require(:expert).permit(:first_name, :last_name, :phone, :email, :state, :city, :license_number, :specialty, :website, :image, :zip, :loan_type, :verified, :email)
    end 
end
