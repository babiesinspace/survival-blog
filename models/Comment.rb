class Comment < ActiveRecord::Base
  belongs_to :author, class_name: 'User',
                      foreign_key: "user_id"
 	has_many :likes, as: :likable
  belongs_to :ancestor, class_name: 'Post',
                      foreign_key: "post_id", 
                      dependent: :destroy
  belongs_to :parent,  class_name: "Comment" #-> requires "parent_id" column
  has_many   :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
end 