class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :role, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :deleted_at
  end
end
