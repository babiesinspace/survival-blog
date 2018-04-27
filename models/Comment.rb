class Comment < ActiveRecord::Base
	belongs_to :author, class_name: 'User',
                      foreign_key: "user_id"
	belongs_to :commentable, polymorphic: true
 	belongs_to :post
  belongs_to :comment
  has_many :comments, as: :commentable
 	has_many :likes, as: :likable
end 