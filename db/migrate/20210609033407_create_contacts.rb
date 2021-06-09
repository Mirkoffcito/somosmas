class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.bigint :phone
      t.string :email, null: false
      t.text :message, null: false
      t.date :deleted_at

      t.timestamps
    end
  end
end
