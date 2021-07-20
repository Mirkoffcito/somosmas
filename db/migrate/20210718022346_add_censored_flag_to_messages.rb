class AddCensoredFlagToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :censored, :boolean, null: false, default: false
  end
end
