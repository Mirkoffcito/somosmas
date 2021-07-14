class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.integer :user1
      t.integer :user2

      t.timestamps
    end
  end
end
