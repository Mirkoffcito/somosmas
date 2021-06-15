class AddForeignKeySlidesToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :slides, :organizations
  end
end
