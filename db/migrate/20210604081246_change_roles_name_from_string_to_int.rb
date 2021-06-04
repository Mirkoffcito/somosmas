class ChangeRolesNameFromStringToInt < ActiveRecord::Migration[6.0]
  def change
    remove_column :roles, :name
    add_column :roles, :name, :int
  end
end
