class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.references :company, foreign_key: true
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.string :title, null: false
      t.string :phone_number, null: false
      t.boolean :admin, default: false, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end