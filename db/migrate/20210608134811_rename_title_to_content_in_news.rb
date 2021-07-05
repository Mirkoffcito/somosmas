class RenameTitleToContentInNews < ActiveRecord::Migration[6.0]
  def change
    rename_column :news, :title, :content
    add_column :news, :category_id, :bigint
    add_foreign_key :news, :categories
  end
end
