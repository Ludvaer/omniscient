class CreateAccountActivations < ActiveRecord::Migration
  def change
    create_table :account_activations do |t|
      t.string :token
      t.integer :user_id
      t.string :email
      t.timestamps
    end
    add_index :account_activations, :user_id, unique: false
    add_column :users, :activated, :boolean, default: false  
  end
end
