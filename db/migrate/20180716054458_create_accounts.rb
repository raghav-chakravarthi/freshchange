class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
    	t.string :owner_name
    	t.string :email
    	t.string :team_name
    	
      t.timestamps
    end
  end
end
