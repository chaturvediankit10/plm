class RenameUserFavoriteColumn < ActiveRecord::Migration[5.1]
  def change
  	rename_column :user_favorites, :program_id, :fav_loan_program_id
  	rename_column :user_favorites, :favorite_url, :fav_search_url
  	rename_column :user_favorites, :favorite_loan, :fav_loan_data
  	rename_column :user_favorites, :favorite_search, :fav_search_data
  end
end
