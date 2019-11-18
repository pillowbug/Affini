class CreateConnectionTags < ActiveRecord::Migration[5.2]
  def change
    create_table :connection_tags do |t|
      t.references :connection, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
