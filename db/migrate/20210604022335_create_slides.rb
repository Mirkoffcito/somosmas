class CreateSlides < ActiveRecord::Migration[6.0]
  def change
    create_table :slides do |t|
      t.string :image_url, null: false
      t.string :text
      t.bigint :order
      t.bigint :organization_id
      t.timestamps
    end
  end
end
