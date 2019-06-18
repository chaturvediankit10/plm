class DirectoriesController < ApplicationController
=begin
  Developer:      Varun
  Created:        19-05-2018
  Purpose:        for all directory pages
=end
  include ApplicationHelper
  #apply dry concept for performing common operations
  before_action :state_name, only: [:mortgage_state_cities,:mortgage_state_cities_list, :refinance_state_cities, :refinance_state_cities_list]
  before_action :banks_search, only: [:mortgage_state_banks, :personal_loan_state_banks, :auto_loan_state_banks]
  before_action :cities_in_state, only: [:mortgage_state_cities, :refinance_state_cities]
  before_action :city_list, only: [:mortgage_state_cities_list, :refinance_state_cities_list] 
  before_action :state_banks_list, only: [:mortgage_state_banks_list, :personal_loan_state_banks_list, :auto_loan_state_banks_list]
  
  def directory_root
    @states = City.select(:state_code).distinct
  end

  def mortgage_state_cities
    @flag = 'mortgage'
  end

  def mortgage_state_cities_list
    @flag = 'mortgage'
  end
   
  def refinance_state_cities
    @flag = 'refinance'
  end

  def refinance_state_cities_list
    @flag = 'refinance'
  end

  def mortgage_state_banks
    @flag = 'mortgage_loan'
    @heading = 'Mortgage'
  end

  def personal_loan_state_banks
    @flag = 'personal_loan'
    @heading = 'Personal Loan'
  end

  def auto_loan_state_banks
    @flag = 'auto_loan'
    @heading = 'Auto Loan'
  end

  def mortgage_state_banks_list
    @flag = 'mortgage_loan'
  end

  def personal_loan_state_banks_list
    @flag = 'personal_loan'
  end

  def auto_loan_state_banks_list
    @flag = 'auto_loan'
  end

  private
    def state_name
      @state_name= params[:state]
    end
    
    def banks_search
      @alphabet= params[:alphabet]
      @banks= if @alphabet == '1'
        FdicInstitution.search_term_special  
      else
        FdicInstitution.search_term(@alphabet)
      end
    end
    
    def cities_in_state
      @cities = City.city_in_state(params[:state])
    end

    def city_list
      city_from = params[:city_from]
      city_to = params[:city_to]
      if city_from.present? && city_to.present?
        city_list_data = City.cities_list(city_from,city_to,@state_name) 
          if city_list_data
            @cities = city_list_data
          else
            content_not_found   #rendering 404 page if ids are not present
          end   
      else 
        content_not_found  #rendering 404 page if city is not present
      end 
    end

    def state_banks_list
      bank_from = params[:bank_from]
      bank_to = params[:bank_to]
      alphabet = params[:alphabet]
      if bank_from.present? && bank_to.present? && alphabet.present?
        if alphabet == '1'             #for special alphabet or number
          special_banks = FdicInstitution.banks_list_special(bank_from, bank_to)
            if special_banks
              @banks = special_banks
            else 
              content_not_found   #rendering 404 page if ids are not present
            end       
        else 
           normal_banks = FdicInstitution.banks_list(alphabet,bank_from, bank_to) 
          if normal_banks
            @banks = normal_banks
          else
            content_not_found    #rendering 404 page if ids are not present
          end    
        end
      else 
        content_not_found       #rendering 404 page if ids are not present
      end   
    end  
end
