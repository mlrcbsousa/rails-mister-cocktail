class AddPictureUrlToCocktail < ActiveRecord::Migration[5.2]
  def change
    add_column :cocktails, :picture_url, :string
  end
end
