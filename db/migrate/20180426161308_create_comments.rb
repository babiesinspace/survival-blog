class CreateComments < ActiveRecord::Migration[5.2]
  def change
  	create_table :comments do |t|
  		t.text :content, null: false
  		t.references :user
  		t.references :post
      t.integer :parent_id
  		t.timestamps
  	end 
  end
end
