class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.integer :user1_id, null: false
      t.integer :user2_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
