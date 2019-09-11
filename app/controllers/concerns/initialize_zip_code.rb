module InitializeZipCode
  extend ActiveSupport::Concern
  
  def initialize_state_and_zip_code
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
      get_expert_list(city)
    end
  end

  def initialize_zip_code_for_seo_pages
    @zip_code = "94035"
    if params[:zip].present?
      @zip_code = ('%05d' % params[:zip])
    end
    city = nil
    if params[:state].present? && params[:city].present?
      @city_name = params[:city].include?('+') ? params[:city].tr('+', ' ') : params[:city]
      city = City.where(state_code: params[:state], city: @city_name).first
      @zip_code = city.present? ? ('%05d' % city.zip) : ('%05d' % @zip_code)
    end
    @state_code = city.present? ? city.state_code : "All"
    @term = params[:term].present? ? params[:term] : "30"
    if current_user.present?
      get_expert_list(city)
    end
  end

  def get_expert_list(city)
    expert_all = Expert.all
    if city.present?
      expert_list_1 = expert_all.where( city: city.city, state: city.state_code ).sort_by(&:created_at).reverse.first(4)
      expert_list_2 = []
      expert_list_2 = expert_all.where(state: city.state_code).where.not(id: expert_list_1).sort_by(&:created_at).reverse.first(4-expert_list_1.count) if expert_list_1.count < 4
      @experts = expert_list_1.count<4 ? (expert_list_1 + expert_list_2) : expert_list_1
      @experts = @experts + (expert_all.where.not(id: @experts).sort_by(&:created_at).reverse.first(4-@experts.count)) if (@experts.count<4)
    else
      @experts = expert_all.sort_by(&:created_at).reverse.first(4)
    end
  end

end