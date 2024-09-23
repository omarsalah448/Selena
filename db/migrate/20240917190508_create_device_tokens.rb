class CreateDeviceTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :device_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_id
      t.timestamps
    end
  end
end