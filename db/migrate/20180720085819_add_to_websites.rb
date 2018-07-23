class AddToWebsites < ActiveRecord::Migration[5.2]
  def change
  	add_column :websites, :priority, :boolean
  	add_column :websites, :was_updated, :boolean
  	add_column :websites, :report_one, :datetime
  	add_column :websites, :report_two, :datetime
  	add_column :websites, :report_three, :datetime
  end
end
