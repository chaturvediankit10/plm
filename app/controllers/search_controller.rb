class SearchController < SearchApi::DashboardController
  
  def home
    api_search
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

  def fetch_programs
    fetch_programs_by_bank
  end

  def set_state_by_zip_code
    zip_code = ''
    if params[:geo_coder].present?
      results = Geocoder.search([params[:latitude].to_f, params[:longitude].to_f])
      zip_code = results.first.postal_code if results.first.present?
    else
      zip_code = params[:zip].to_i if params[:zip].present?
    end
    city = City.find_by_zip(zip_code.to_i) if zip_code.present?
    respond_to do |format|
      format.json {render :json => {state: city.present? ? city.state_code : "All", zip_code: zip_code }}
    end
  end
end
