=begin
  Developer:      Varun
  Created:        16-03-2018
  Purpose:        Following actions are for status update in admin panel .
=end
class PagesController < SearchController
  include InitilizeZipCode
  before_action :authenticate_user!, only: [:secret]
  before_action :update_statue, only: [:change_status, :user_mass_activate, :user_mass_deactivate]

  def index
    @experts = Expert.where(verified: true).last(5)
  end

  def show
    # page = CmsPage.find_by(page_slug: params[:page_slug])
    # if page
    #   @page = page
    # else
    #    content_not_found
    # end
    page = params[:page_slug]
    if page
      @page = page
    else
      content_not_found
    end
  end

  def refinance
    params[:loan_purpose] = "Refinance" if params[:loan_purpose].nil?
    initilize_state_and_zip_code
    api_search if params[:commit].present?
    if params[:loan_type] == "ARM" && params[:arm_basic].present?
      @arm_term = 51
    else
      @arm_term = params[:term].present? ? params[:term] : @term
    end
  end

  def mortgage
    api_search if params[:commit].present?
    initilize_state_and_zip_code
    if params[:loan_type] == "ARM" && params[:arm_basic].present?
      @arm_term = 51
    else
      @arm_term = params[:term].present? ? params[:term] : @term
    end
  end

  def favorite_program
    if current_user.present?
      if current_user.user_favorites.pluck(:program_id).include?(params[:program_id].to_i)
        UserFavorite.find_by_program_id(params[:program_id]).delete
        data = "delete"
      else
        user_favorite =  current_user.user_favorites.find_or_create_by(program_id: params[:program_id].to_i, favorite_loan: params[:program])
        data = "create"
      end
      # user_favorite =  current_user.user_favorites.find_or_create_by(program_id: params[:program_id].to_i, favorite_data: params[:form_data].except(:authenticity_token, :utf8),favorite_url: params[:favorite_url], favorite_loan: params[:program])
      
      respond_to do |format|
        format.json  { render :json => {status: true,data: data} }
      end
    else
     respond_to do |format|
        format.json  { render :json => {status: false} }
      end
    end
  end

  def add_favorite_program
    if current_user.present?
      user_favorite =  current_user.user_favorites.find_or_create_by(program_id: params[:program][:id].to_i, favorite_loan: params[:program][:favorite_loan])
      respond_to do |format|
        format.json  { render :json => {status: true} }
      end
    end
  end

  def favorite_searches
    if current_user.present?
      if current_user.user_favorites.find_by_favorite_search(params[:form_data].except(:authenticity_token, :utf8)) == nil
        user_favorite_search = current_user.user_favorites.find_or_create_by(favorite_search: params[:form_data].except(:authenticity_token, :utf8),favorite_url: params[:favorite_url])
        respond_to do |format|
          format.json  { render :json => {status: true} }
        end
      elsif current_user.user_favorites.find_by_favorite_search(params[:form_data].except(:authenticity_token, :utf8)).present?
        current_user.user_favorites.find_by_favorite_search(params[:form_data].except(:authenticity_token, :utf8)).delete
        respond_to do |format|
          format.json  { render :json => {status: false} }
        end
      end
    else
      respond_to do |format|
        format.json  { render :json => {status: false} }
      end
    end
  end

  def favorite_search_heart
    if current_user.present?
      if current_user.user_favorites.find_by_favorite_search(params[:form_data].except(:authenticity_token, :utf8)) == nil
        respond_to do |format|
          format.json  { render :json => {status: true} }
        end
      else
        respond_to do |format|
          format.json  { render :json => {status: false} }
        end
      end
    end
  end

  def delete_favorite
    user = User.find(params[:user_id])
    if user.present?
      user_favorite = user.user_favorites.find_by(id: params[:fav_id])
      if user_favorite.delete
        respond_to do |format|
          format.json  { render :json => {status: true, fav_id: params[:fav_id], fav_loan: params[:fav_loan]} }
        end
      end
    end
  end

  def send_mail
    if current_user.present?
      if current_user.price_alert.present?
        ContactUsMailer.daily_price_alert_email(current_user).deliver
      end
    end
    redirect_to edit_user_registration_path
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
    flash[:notice] = "Thank you! Your message has been submitted."
    redirect_back fallback_location: root_path
	end

  def research_contact_us_email
    @admin_user = AdminUser.first.email
     receivers  = ["ray@relativityteam.com", "tzewee@relativityteam.com", "nicky@relativityteam.com", "linda@relativityteam.com", @admin_user]
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
    flash[:notice] = 'Thank you! Your message has been submitted.'
    # flash[:notice] = 'Research submitted successfully.'
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
      # city_zip = params[:expert][:city].split(',')
      city_zip = params[:expert]
      # @expert_user.city = city_zip[0]
      @expert_user.city = city_zip[:city]
      # @expert_user.zip = city_zip[1]
      @expert_user.zip = city_zip[:zip]
      begin
        @expert_user.save!
        # flash[:notice] = 'You are succesfully registered as expert.'
        flash[:notice] = 'Thank you! Your message has been submitted.'
      rescue => e
        flash[:danger] = "Your account already exists."
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
     render json: zip.map{ |z|  ('%05d' % z) }
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

  def bank_page_info
    @bank = Bank.find_by_name(params[:bank_name])
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
