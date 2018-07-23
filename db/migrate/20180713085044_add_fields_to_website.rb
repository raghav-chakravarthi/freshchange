class AddFieldsToWebsite < ActiveRecord::Migration[5.2]
  def change
  	add_column :websites, :old_time, :datetime
  	add_column :websites, :new_time, :datetime
  	add_column :websites, :diff_time, :datetime
  	add_column :websites, :friendly_name, :string
  end
end
