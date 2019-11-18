class CreateCheckins < ActiveRecord::Migration[5.2]
  def change
    create_table :checkins do |t|
      t.references :user, foreign_key: true
      t.integer :rating
      t.datetime :time
      t.text :description
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
