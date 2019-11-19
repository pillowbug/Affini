class CreateCheckinsConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :checkins_connections do |t|
      t.references :checkin, foreign_key: true
      t.references :connection, foreign_key: true
    end
  end
end
