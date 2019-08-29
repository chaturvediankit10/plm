class SearchController < SearchApi::DashboardController
  include InitilizeZipCode
  include ActiveTab

  def home
    initilize_state_and_zip_code
    initilize_term_loan_type if params[:commit].present? && params[:ajax_call].nil?
    api_search if params[:commit].present?

    respond_to do |format|
	    format.html
	    format.js # actually means: if the client ask for js -> return file.js
	  end
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
