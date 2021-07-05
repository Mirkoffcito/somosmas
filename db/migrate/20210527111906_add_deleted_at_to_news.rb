class AddDeletedAtToNews < ActiveRecord::Migration[6.0]
  def change
    add_column :news, :deleted_at, :datetime
    add_index :news, :deleted_at
  end
end
