class CreateUsers < ActiveRecord::Migration[5.2]
  def change
  	create_table :users do |t|
  		t.string :name
  		t.string :handle
  		t.string :email, null: false
  		t.string :password, null: false
  		t.boolean :admin, default: false
  		
  		t.timestamps
  	end
  end
end
