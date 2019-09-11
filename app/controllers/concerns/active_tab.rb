module ActiveTab
  extend ActiveSupport::Concern
  def initialize_term_loan_type
    if params[:term_30_list].present?
      params[:term] = 30
      params[:loan_type] = "Fixed"
      @arm_term = "30"
    elsif params[:term_15_list].present?
      params[:term] = 15
      params[:loan_type] = "Fixed"
      @arm_term = "15"
    elsif params[:term_10_list].present?
      params[:term] = 10
      params[:loan_type] = "Fixed"
      @arm_term = "10"
    elsif params[:arm_basic_7_list].present?
      params[:arm_basic] = "7/1"
      params[:loan_type] = "ARM"
      @arm_term = "71"
    elsif params[:arm_basic_5_list].present?
      params[:arm_basic] = "5/1"
      params[:loan_type] = "ARM"
      @arm_term = "51"
    end
  end
end