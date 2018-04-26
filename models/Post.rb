class Post < ActiveRecord::Base
	belongs_to :user, foreign_key: 'author_id'
	has_many :comments, as :commentable
	has_many :likes, as :likable
	has_many :tagged_posts
	has_many :tags, through: :tagged_posts
end 