class RemoveImageUrlFromSlides < ActiveRecord::Migration[6.0]
  def change
    remove_column :slides, :image_url, :string
  end
end
