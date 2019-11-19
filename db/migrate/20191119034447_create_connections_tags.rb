class CreateConnectionsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :connections_tags do |t|
      t.references :connection, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
