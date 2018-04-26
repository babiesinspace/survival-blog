require 'faker'
require 'bcrypt'

# alex = User.create(name: "Alexandra", handle: "babiesinspace", email: "allie.g.cooper@gmail.com", password: "password321", admin: true)

# 10.times do |e|
# 	User.create(name: Faker::Name.name, handle: Faker::Internet.user_name, email: Faker::Internet.email, password: Faker::Internet.password)
# end

# 10.times do |e|
# 	Post.create(title: Faker::VForVendetta.quote, body: Faker::VForVendetta.speech, author: User.find(1))
# end 

# 5.times do |e|
# 	Post.all.each do |post|
# 		post.comments.create(content: Faker::Seinfeld.quote, author: User.find(rand(2..11)))
# 	end 
# end

# Comment.all.each do |comment|
# 	comment.comments.create(content: Faker::Seinfeld.quote, author: User.find(rand(1..11)))
# end 

# 20.times do |e|
# 	Post.all.each do |post|
# 		post.likes.create(user_id: User.find(rand(1..11)).id)
# 	end
# 	Comment.all.each do |post|
# 		post.likes.create(user_id: User.find(rand(1..11)).id)
# 	end
# end