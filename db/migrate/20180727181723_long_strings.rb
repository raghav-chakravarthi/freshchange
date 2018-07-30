class LongStrings < ActiveRecord::Migration[5.2]
  def change
  	change_column :websites, :analytics, :text, :limit => 4294967295
  end
end
