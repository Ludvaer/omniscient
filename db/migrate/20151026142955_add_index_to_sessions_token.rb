class AddIndexToSessionsToken < ActiveRecord::Migration
  def change
  	add_index :sessions, :token, unique: true
  end
end
