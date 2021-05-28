class ChangeColumnToCategory < ActiveRecord::Migration[6.0]
  def change
    change_column :categories, :name, :null => false 
  end
end
