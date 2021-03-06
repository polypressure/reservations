class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.string :email

      t.timestamps null: false

      t.index [:last_name, :first_name]
    end
  end
end
