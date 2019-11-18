class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.string :first_name
      t.string :last_name
      t.text :description
      t.date :birthday
      t.string :frequency
      t.string :email
      t.string :facebook
      t.string :linkedin
      t.string :phone_number
      t.string :instagram
      t.string :twitter
      t.string :photo
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
