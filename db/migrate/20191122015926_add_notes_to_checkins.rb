class AddNotesToCheckins < ActiveRecord::Migration[5.2]
  def change
    add_column :checkins, :notes, :text
    change_column :checkins, :description, :string
  end
end
