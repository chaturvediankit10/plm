class AddColumnsToUserFavorite < ActiveRecord::Migration[5.1]
  def change
    add_column :user_favorites, :program_id, :integer
    add_column :user_favorites, :favorite_data, :text
    add_column :user_favorites, :favorite_url, :string
  end
end
