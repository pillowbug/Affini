class CreateAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :attendees do |t|
      t.references :checkin, foreign_key: true
      t.references :connection, foreign_key: true

      t.timestamps
    end
  end
end
