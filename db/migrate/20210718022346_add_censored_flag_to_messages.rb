class AddCensoredFlagToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :censored, :boolean, default: false
  end
end
