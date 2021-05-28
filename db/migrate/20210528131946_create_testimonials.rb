class CreateTestimonials < ActiveRecord::Migration[6.0]
  def change
    create_table :testimonials do |t|
      t.string :name, null: false
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
