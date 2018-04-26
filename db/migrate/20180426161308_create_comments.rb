class CreateComments < ActiveRecord::Migration[5.2]
  def change
  	create_table :comments do |t|
  		t.text :content
  		t.references :author, index: true, foreign_key: { to_table: :users }
  		t.references :commentable, :polymorphic => true
  		
  		t.timestamps
  	end 
  end
end
