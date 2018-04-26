class Tag < ActiveRecord::Base
	has_many :tagged_posts
	has_many :posts, through: :tagged_posts
end 