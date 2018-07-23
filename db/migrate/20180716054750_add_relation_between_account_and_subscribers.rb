class AddRelationBetweenAccountAndSubscribers < ActiveRecord::Migration[5.2]
  def change
  	add_column :subscribers, :password, :string
  	add_column :subscribers, :admin, :boolean
  	add_column :subscribers, :has_accrss, :boolean
  	add_column :subscribers, :created, :boolean
  	add_column :subscribers, :account_id, :integer
  end
end
