class User < ActiveRecord::Base
	has_many :posts
	def name_and_age
		name + " : " + age.to_s
	end
end

class Post < ActiveRecord::Base
	belongs_to :user
end

# class Follow < ActiveRecord::Base
# 	belongs_to :user
# end   #follow.create(follow_id, followee_id)