class DropNewsTable < ActiveRecord::Migration[6.0]
  def change
      drop_table :news
  end
end
