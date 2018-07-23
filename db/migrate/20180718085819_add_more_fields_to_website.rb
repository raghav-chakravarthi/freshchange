class AddMoreFieldsToWebsite < ActiveRecord::Migration[5.2]
  def change
  	add_column :websites, :analytics, :string
  	add_column :websites, :scheduled, :integer
  end
end
