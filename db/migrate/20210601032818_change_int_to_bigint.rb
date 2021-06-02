class ChangeIntToBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :organizations, :phone, :bigint
  end
end
