class Comment < ActiveRecord::Base
	belongs_to :user, foreign_key: 'author' #'author_id'?
	belongs_to :commentable, polymorphic: true
 	has_many :comments, as: :commentable
 	has_many :likes, as: :likable
end 