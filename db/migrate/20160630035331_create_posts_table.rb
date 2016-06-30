class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |table|
  		table.string :posts 
  	end
  end
end
