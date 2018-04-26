class CreateTaggedPosts < ActiveRecord::Migration[5.2]
  def change
  	create_table :tagged_posts do |t|
  		t.references :post
  		t.references :tag
  		
  		t.timestamps
  	end 
  end
end
