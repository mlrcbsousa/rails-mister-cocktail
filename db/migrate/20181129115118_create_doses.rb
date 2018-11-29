class CreateDoses < ActiveRecord::Migration[5.2]
  def change
    create_table :doses do |t|
      t.string :description
      t.cocktail :references
      t.ingredient :references

      t.timestamps
    end
  end
end
