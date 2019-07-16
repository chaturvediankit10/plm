class SeoPagesController < SearchController
=begin
Developer:      Varun
Created:        21-05-2018
Purpose:        display and define logic for all the seo pages
=end  
  include ApplicationHelper
  include SeoPagesHelper
  include InitilizeZipCode

  #apply dry concept for common code
  before_action :default_programs, only: [:city_home_mortgage_rates, :city_home_refinance_rates, :bank_mortgage_loans]
  before_action :city_home, only: [:city_home_mortgage_rates, :city_home_refinance_rates]
  before_action :bank_home, only: [:bank_mortgage_loans, :bank_personal_loans, :bank_auto_loans]

  def city_home_mortgage_rates
    initilize_state_and_zip_code
    @news_articles = news_article_data(' mortgage')
    # for report section fetching all cities record similer to current city 
    cached_data = FreddieMacCache.find_by('zip_prefix like ? and loan_type = ?', "#{@city.zip.to_s.first(3)+ '%'}", 'P')
    unless cached_data.present? 
      cached_data = FreddieMacCache.find_by('zip_prefix like ? and loan_type = ?', "#{@city.zip.to_s.first(2)+ '%'}", 'P')
    end
    @header =  ((DateTime.now - 8.year)..(DateTime.now - 1.year)).map{|y| y.year}.uniq  if cached_data.present?
    @report = cached_data.freddie_data     if cached_data.present? 
    #section end
    @loan_companies = FactualMortgageCompany.loan_companies_for_city(@city)
  end 

  def city_home_refinance_rates
    initilize_state_and_zip_code
    @news_articles = news_article_data(' refinance')
    # for report section fetching all cities record similer to current city
    # for loan type N & C
    cached_data = FreddieMacCache.find_by('zip_prefix like ? and loan_type = ?', "#{@city.zip.to_s.first(3)+ '%'}", 'N')
    unless cached_data.present? 
      cached_data = FreddieMacCache.find_by('zip_prefix like ? and loan_type = ?', "#{@city.zip.to_s.first(2)+ '%'}", 'N')
    end  
    @header =  ((DateTime.now - 8.year)..(DateTime.now - 1.year)).map{|y| y.year}.uniq  if cached_data.present?
    @report = cached_data.freddie_data     if cached_data.present?
    #section end  
    @loan_officers = LoanOfficer.loan_officers_for_city(@city)
  end 

  def bank_mortgage_loans
    initilize_state_and_zip_code
    @news_articles = bank_news_article(" mortgage")
    @loan_officers = LoanOfficer.loan_officers_gen(@bank, "mortgage")
  end
    
  def bank_personal_loans 
    @news_articles = bank_news_article(" personal loans")
    @loan_officers = LoanOfficer.loan_officers_gen(@bank, "personal loan")
  end  

  def bank_auto_loans
    @news_articles = bank_news_article(" auto loans")
    @loan_officers = LoanOfficer.loan_officers_gen(@bank, "auto loan")
  end

  private
    #common function for all city home pages
    def city_home
      city_home = City.find_by(id: params[:city_id])
      if city_home.present?
        @city = city_home
        @zip = @city.zip            #for modals 
        @state = state_full_name(city_home.state_code, false) 
        all_city = City.where.not(city: @city.city).where(state_code: @city.state_code).select('distinct on (city) *')
        g_city = all_city.to_a.map{|c| c.zip   if c.zip > @city.zip}.compact.sort.first(2)
        l_city = all_city.to_a.map{|c| c.zip   if c.zip < @city.zip}.compact.sort.last(3)
         @near_by_cities = City.where(zip: g_city.to_a + l_city.to_a).order(:zip)         
      else
        content_not_found
      end  
    end  

    def news_article_data(flag)
      city_news_articles = NewsArticle.where("search_term = ? OR search_term = ?", @city.city+flag, @city.city+', '+@city.state_code+flag)
      return city_news_articles.order(id: :desc).first(10)
    end
    #common function for all bank home pages
    def bank_home
      bank_home = FdicInstitution.find_by(cert: params[:cert])
      if bank_home.present? && bank_home.used
        @state =  bank_home.stname
        @bank = bank_home
        @zip = @bank.zip        #for modals
        @state_code = state_full_name(bank_home.stname, true)
        @near_by_banks = FdicInstitution.near_by_banks(bank_home.cert)
        @fdic_cal_data = FdicCalculation.find_by(cert: params[:cert])
      else
        content_not_found
      end  
    end

    def bank_news_article(flag)
      bank_news_articles = NewsArticle.where(search_term: @bank.name+flag)
      return bank_news_articles.order(id: :desc).first(10)
    end

    def default_programs
      params.delete :bank_name if params[:action] == "bank_mortgage_loans"
      home
    end
end
