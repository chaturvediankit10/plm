class SearchController < SearchApi::DashboardController
  
  def home
    list_of_banks_and_programs_with_search_results
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
end
