class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.text :detail, null: false
      t.boolean :modified, default: false
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
