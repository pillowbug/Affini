class CreateGlances < ActiveRecord::Migration[5.2]
  def change
    create_table :glances do |t|
      t.text :question
      t.text :answer
      t.references :connection, foreign_key: true

      t.timestamps
    end
  end
end
