class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |table|
  		table.string :username 
  		table.string :password
  		table.string :name
  		table.integer :age
  	end
  end
end
