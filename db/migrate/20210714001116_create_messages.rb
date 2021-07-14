class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer :user_id, null: false
      t.text :detail, null: false
      t.boolean :modified, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
