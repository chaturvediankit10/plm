class UserFavorite < ApplicationRecord
  #associated with users table
  belongs_to :user
  serialize :favorite_data, JSON
  serialize :favorite_loan, JSON
  # needs to be done
  #belongs_to :loan_tek_data
end
