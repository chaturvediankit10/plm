class AddFavoriteSearchToUserFavorites < ActiveRecord::Migration[5.1]
  def change
    add_column :user_favorites, :favorite_search, :text
  end
end
