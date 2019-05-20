=begin
  Developer:      Varun
  Created:        16-03-2018
  Purpose:        Following actions are for status update in admin panel .
=end
class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:secret]
  before_action :update_statue, only: [:change_status, :user_mass_activate, :user_mass_deactivate]

  def index
    @experts = Expert.where(verified: true).last(5)
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
