class AddCategoryToConnections < ActiveRecord::Migration[5.2]
  def change
    add_column :connections, :category, :string
  end
end
