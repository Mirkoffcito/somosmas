class AddDeletedAtToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :deleted_at, :datetime
    add_index :categories, :deleted_at
  end
end
