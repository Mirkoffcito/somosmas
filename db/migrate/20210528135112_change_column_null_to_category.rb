class ChangeColumnNullToCategory < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:categories, :name, true)
  end
end
