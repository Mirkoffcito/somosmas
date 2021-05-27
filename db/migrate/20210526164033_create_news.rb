class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.string :name, null: false
      t.text :title
      t.timestamps
    end
  end
end
