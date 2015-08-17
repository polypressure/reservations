class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :datetime, null: false
      t.integer :party_size, null: false
      t.integer :table_id, null: false
      t.integer :customer_id, null: false

      t.timestamps null: false

      t.index [:table_id, :datetime]
    end

    add_foreign_key :reservations, :table_id
    add_foreign_key :reservations, :customer_id
  end
end
