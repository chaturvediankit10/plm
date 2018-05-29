class SeoPagesController < ApplicationController
  include ApplicationHelper
  include SeoPagesHelper
  #apply dry concept for common code
  before_action :city_home, only: [:city_home_mortgage_rates, :city_home_refinance_rates]
  before_action :bank_home, only: [:bank_mortgage_loans, :bank_personal_loans, :bank_auto_loans]

  def city_home_mortgage_rates
    @news_articles = news_article_data(' mortgage')
    # for report section fetching all cities record similer to current city 
    cached_data = FreddieMacCache.find_by(city_id: params[:city_id], loan_type: 'P')
    if cached_data.present?
      @header = eval(cached_data.freddie_data.first(1).to_h.values.first).keys.sort
      @report = cached_data.freddie_data
      @flag = true
    else
      @header, @report = historial_rates_report(@similer_cities, 'P')
      @flag = false
      FreddieMacWorker.perform_async(params[:city_id],'P',@header, @report.to_json)
    end 
    #section end
    @loan_companies = FactualMortgageCompany.loan_companies_for_city(@city.zip)
  end 

  def city_home_refinance_rates
    @news_articles = news_article_data(' refinance')
    # for report section fetching all cities record similer to current city
    # for loan type N & C
    cached_data = FreddieMacCache.find_by(city_id: params[:city_id], loan_type: 'N') 
    if cached_data.present?
      @header = eval(cached_data.freddie_data.first(1).to_h.values.first).keys.sort
      @report = cached_data.freddie_data
      @flag = true
    else
      @header, @report = historial_rates_report(@similer_cities, 'N')
      @flag = false
      FreddieMacWorker.perform_async(params[:city_id],'N',@header, @report.to_json)
    end
    #section end  
    @loan_officers = LoanOfficer.loan_officers_for_city(@city.zip)
  end 

  def bank_mortgage_loans
    @news_articles = bank_news_article(" mortgage")
    #fetch loanofficer data using fuzzy search on the basis of search terms      
    @loan_officers= LoanOfficer.loan_officers_list(@bank.name, 'home')
    @loan_officers= LoanOfficer.loan_officers_list(@bank.name, 'mortgage')    unless @loan_officers.present?
    @security = FdicSecurity.find_by(cert: @bank.cert)
    @good_will = FdicGoodwillAndOtherIntangible.find_by(cert: @bank.cert)
    @managed_assets = FdicTotalManagedAssetsHeldInFiduciaryAccount.find_by(cert: @bank.cert)
    @net_loan_and_leases = FdicNetLoansAndLease.find_by(cert: @bank.cert)
  end
    
  def bank_personal_loans 
    @news_articles = bank_news_article(" personal loans")
    @loan_officers = LoanOfficer.loan_officers_list(@bank.name,'personal')
    @past_due_and_assets = FdicPastDueAndNonaccrualAsset.find_by(cert: @bank.cert)
    @loss_share = FdicCarryingAmountOfAssetsCoveredByFdicLossShareAgreement.find_by(cert: @bank.cert)
    @bank_assets_and_sec = FdicBankAssetsSoldAndSecuritized.find_by(cert: @bank.cert)
    @max_amt_and_credit = FdicMaximumAmountOfCreditExposureRetained.find_by(cert: @bank.cert)
  end  

  def bank_auto_loans
    @news_articles = bank_news_article(" auto loans")
    @loan_officers = LoanOfficer.loan_officers_list(@bank.name,'auto')
    @net_loan_and_leases = FdicNetLoansAndLease.find_by(cert: @bank.cert)
    @past_due_and_assets = FdicPastDueAndNonaccrualAsset.find_by(cert: @bank.cert)
    @bank_assets_and_sec = FdicBankAssetsSoldAndSecuritized.find_by(cert: @bank.cert)
    @max_amt_and_credit = FdicMaximumAmountOfCreditExposureRetained.find_by(cert: @bank.cert)
    @loan_charges_off = FdicLoanChargeOffsAndRecovery.find_by(cert: @bank.cert)
  end

  private

    def city_home
      city_home = City.find_by(id: params[:city_id])
      if city_home.present?
        @city = city_home
        @state = state_full_name(city_home.state_code, false) 
        g_city = City.where('zip > ?',@city.zip).limit(50).select('distinct on (city) *').to_a
        l_city = City.where('zip < ?',@city.zip).limit(50).select('distinct on (city) *').to_a
        @near_by_cities = g_city + l_city
        #old logic
        #@near_by_cities = []
        #City.where(state_code: city_home.state_code).where.not(city: @city.city).group_by(&:city).each do |key, val|
          #if val.count == 1
            #@near_by_cities << val
          #else
           # @near_by_cities << val.first
          #end
        #end         
       @similer_cities = City.where(city: @city.city, state_code: @city.state_code).pluck(:zip) 
      else
        content_not_found
      end  
    end  

    def news_article_data(flag)
      city_news_articles = NewsArticle.where("search_term = ? OR search_term = ?", @city.city+flag, @city.city+', '+@state+flag)
      return city_news_articles.order(id: :desc).first(10)
    end

    def bank_home
      bank_home = FdicInstitution.find_by(cert: params[:cert])
      if bank_home.present?
        @state =  bank_home.stname
        @bank = bank_home
        @state_code = state_full_name(bank_home.stname, true)
        @near_by_banks = FdicInstitution.near_by_banks(bank_home.cert)
      else
        content_not_found
      end  
    end

    def bank_news_article(flag)
      bank_news_articles = NewsArticle.where(search_term: @bank.name+flag)
      return bank_news_articles.order(id: :desc).first(10)
    end

end
