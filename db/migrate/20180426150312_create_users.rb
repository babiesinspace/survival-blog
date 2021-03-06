class CreateUsers < ActiveRecord::Migration[5.2]
  def change
  	create_table :users do |t|
  		t.string :name, null: false
  		t.string :handle
  		t.string :email, null: false, unique: true
  		t.string :password_digest, null: false
  		t.boolean :admin, default: false
  		
  		t.timestamps
  	end
  end
end
