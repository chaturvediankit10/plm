class RemoveLoanTekDataIdFromUserFavorites < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_favorites, :loan_tek_data_id, :integer
    remove_column :user_favorites, :favorite_data, :text
  end
end
