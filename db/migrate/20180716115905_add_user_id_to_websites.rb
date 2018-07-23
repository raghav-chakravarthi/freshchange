class AddUserIdToWebsites < ActiveRecord::Migration[5.2]
  def change
  	add_column :websites, :user_id, :integer
  	remove_column :websites, :subscriber_id
  end
end
