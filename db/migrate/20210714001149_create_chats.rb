class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.integer :user1, null: false
      t.integer :user2, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
