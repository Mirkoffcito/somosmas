class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.date :deleted_at
    end
  end
end
