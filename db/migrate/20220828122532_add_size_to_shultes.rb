class AddSizeToShultes < ActiveRecord::Migration[7.0]
  def change
    add_column :shultes, :size, :bigint
  end
end
