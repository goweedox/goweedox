require "migration_helpers"
class CreateDocumentations < ActiveRecord::Migration
	extend MigrationHelpers
  def self.up
    create_table :documentations do |t|
      t.integer :user_id, :null => false
      t.string :title
      t.text :description

      t.timestamps
    end
		foreign_key(:documentations, :id, :users)
  end

  def self.down
    drop_table :documentations
  end
end
