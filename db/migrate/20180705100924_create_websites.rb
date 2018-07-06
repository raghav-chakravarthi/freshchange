class CreateWebsites < ActiveRecord::Migration[5.2]
  def change
    create_table :websites do |t|
    	t.string :url
    	t.string :content
    	t.integer :subscriber_id

      t.timestamps
    end
  end
end
