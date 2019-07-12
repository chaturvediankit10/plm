class SearchController < SearchApi::DashboardController
  include Onload
  def home
    api_search
    initilize_state_and_zip_code
    if params[:loan_type] == "ARM" && params[:arm_basic].present?
      @arm_term = 51
    else
      @arm_term = params[:term].present? ? params[:term] : @term
    end
    respond_to do |format|
	    format.html
	    format.js # actually means: if the client ask for js -> return file.js
	  end
  end

  def initilize_state_and_zip_code
    @zip_code = "94035"
    results = Geocoder.search(request.ip)
    @zip_code = results.first.postal_code if results.first.postal_code.present?
    city = City.find_by_zip(@zip_code.to_i) if @zip_code.present?
    @state = city.present? ? city.state_code : "All"
  end

  def fetch_programs
    fetch_programs_by_bank
  end

  def set_state_by_zip_code
    @zip_code = params[:zip].to_i if params[:zip].present?
    city = City.find_by_zip(@zip_code.to_i) if @zip_code.present?
    respond_to do |format|
      format.json {render :json => {state: city.present? ? city.state_code : "All", zip_code: @zip_code }}
    end
  end
end
