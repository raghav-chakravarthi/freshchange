class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :password, :string
  	add_column :users, :admin, :boolean, default: false
  	add_column :users, :has_access, :boolean, default: false
  	add_column :users, :created, :boolean, default: false
  	add_column :users, :account_id, :integer
  	add_column :users, :name, :string
  end
end
