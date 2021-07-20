class CreateProfanities < ActiveRecord::Migration[6.0]
  def change
    create_table :profanities do |t|
      t.string :word, null: false

      t.timestamps
    end
  end
end
