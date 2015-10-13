class AddColumnCaselessUsername < ActiveRecord::Migration
  def change
  	#caseless name, need keep original name still keep validate caseless name uniquess
    add_column :users, :downame, :string
    add_index :users, :downame, unique: true
  end
end
