module InitilizeZipCode
  extend ActiveSupport::Concern
  
  def initilize_state_and_zip_code
    @zip_code = "94035"
    if params[:zip].present?
      @zip_code = params[:zip]
    else
      results = Geocoder.search(request.ip)
      @zip_code = results.first.postal_code if results.first.postal_code.present?
    end
    city = City.find_by_zip(@zip_code.to_i) if @zip_code.present?
    @state_code = city.present? ? city.state_code : "All"
    @term = params[:term].present? ? params[:term] : "30"
    if @state_code == "All"
      @expert_list = Expert.all.sort_by { |m| [m.created_at] }.reverse
    else
      @expert_list = Expert.where(city: city.city).sort_by { |m| [m.created_at] }.reverse
    end
    if params[:loan_type] == "ARM" && params[:arm_basic].present?
      @arm_term = 51
    else
      @arm_term = params[:term].present? ? params[:term] : @term
    end
  end

  def initilize_zip_code_for_seo_pages
    @zip_code = "94035"
    if params[:zip].present?
      @zip_code = params[:zip]
    end
    if params[:state].present? && params[:city].present?
      city_name = params[:city].include?('+') ? params[:city].tr('+', ' ') : params[:city]
      city = City.where(state_code: params[:state], city: city_name).first
      @zip_code = city.present? ? city.zip : @zip_code
    end
    @state_code = city.present? ? city.state_code : "All"
    @term = params[:term].present? ? params[:term] : "30"
    if @state_code == "All"
      @expert_list = Expert.all.sort_by { |m| [m.created_at] }.reverse
    else
      @expert_list = Expert.where(city: city.city).sort_by { |m| [m.created_at] }.reverse
    end
    if params[:loan_type] == "ARM" && params[:arm_basic].present?
      @arm_term = 51
    else
      @arm_term = params[:term].present? ? params[:term] : @term
    end
  end

end