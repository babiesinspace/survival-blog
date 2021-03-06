class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User',
                      foreign_key: "user_id"
	has_many :comments, dependent: :destroy
	has_many :likes, as: :likable
	has_many :tagged_posts
	has_many :tags, through: :tagged_posts
end 