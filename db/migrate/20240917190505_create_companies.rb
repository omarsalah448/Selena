class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :timezone, null: false
      t.integer :work_week_start, null: false

      t.timestamps
    end
  end
end