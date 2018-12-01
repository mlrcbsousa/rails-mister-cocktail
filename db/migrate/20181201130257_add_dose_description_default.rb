class AddDoseDescriptionDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :doses, :description, :string, default: '1 part'
  end
end
