class AddLiveToConnections < ActiveRecord::Migration[5.2]
  def change
    add_column :connections, :live, :datetime, default: nil
  end
end
