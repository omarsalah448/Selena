class AddUniqueConstraintToUsersEmailAndActivated < ActiveRecord::Migration[7.2]
  def up
    remove_index :users, :email if index_exists?(:users, :email)
    add_index :users, [:email, :activated], unique: true
  end

  def down
    remove_index :users, [:email, :activated]
    add_index :users, :email, unique: true
  end
end