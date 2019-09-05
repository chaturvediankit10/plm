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
    @city_name = city.present? ? city.city : nil
    @term = params[:term].present? ? params[:term] : "30"
    if current_user.present?
      expert = Expert.where(city: @city_name).sort_by(&:created_at).reverse.first(4)
      if expert.count<4
        @experts = Expert.where.not(id: expert).sort_by(&:created_at).reverse.first(4-expert.count)
        @experts = @experts+expert
       else
        @experts = expert
      end
    end
  end

  def initilize_zip_code_for_seo_pages
    @zip_code = "94035"
    if params[:zip].present?
      @zip_code = ('%05d' % params[:zip])
    end
    if params[:state].present? && params[:city].present?
      @city_name = params[:city].include?('+') ? params[:city].tr('+', ' ') : params[:city]
      city = City.where(state_code: params[:state], city: @city_name).first
      @zip_code = city.present? ? ('%05d' % city.zip) : ('%05d' % @zip_code)
    end
    @state_code = city.present? ? city.state_code : "All"
    @term = params[:term].present? ? params[:term] : "30"
    if current_user.present?
      expert = Expert.where(city: @city_name).sort_by(&:created_at).reverse.first(4)
      if expert.count<4
        @experts = Expert.where.not(id: expert).sort_by(&:created_at).reverse.first(4-expert.count)
       else
        @experts = expert
      end
    end

  end

end