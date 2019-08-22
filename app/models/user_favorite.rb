class UserFavorite < ApplicationRecord
  #associated with users table
  belongs_to :user
  serialize :favorite_data, JSON
  serialize :fav_loan_data, JSON
  serialize :fav_search_data, JSON
  # needs to be done
  #belongs_to :loan_tek_data
end
