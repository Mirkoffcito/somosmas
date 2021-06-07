class AddDefaultValueToRolesName < ActiveRecord::Migration[6.0]
  def change
    change_column :roles, :name, :string, default: 'admin'
  end
end
