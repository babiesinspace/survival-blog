class Like < ActiveRecord::Base
	belongs_to :user
  belongs_to :comment
  belongs_to :post
	belongs_to :likable, polymorphic: true
end 