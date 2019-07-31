module InitilizeZipCode
  extend ActiveSupport::Concern
  
  def initilize_state_and_zip_code
    @zip_code = "94035"
    results = Geocoder.search(request.ip)
    @zip_code = results.first.postal_code if results.first.postal_code.present?
    city = City.find_by_zip(@zip_code.to_i) if @zip_code.present?
    @state_code = city.present? ? city.state_code : "All"
  end
end
