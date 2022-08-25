class AddActivatedToActivations < ActiveRecord::Migration[5.1]
  def change
  	add_column :account_activations, :activated, :boolean, default: false
  end
end
