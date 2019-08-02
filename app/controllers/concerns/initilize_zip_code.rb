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
  end
end