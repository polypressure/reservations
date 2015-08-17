class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :seats, null: false, index: true

      t.timestamps null: false
    end
  end
end
