# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150806220743) do

  create_table "customers", force: :cascade do |t|
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.string   "phone",      null: false
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["last_name", "first_name"], name: "index_customers_on_last_name_and_first_name"

  create_table "reservations", force: :cascade do |t|
    t.datetime "datetime",    null: false
    t.integer  "party_size",  null: false
    t.integer  "table_id",    null: false
    t.integer  "customer_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reservations", ["table_id", "datetime"], name: "index_reservations_on_table_id_and_datetime"

  create_table "tables", force: :cascade do |t|
    t.integer  "seats",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tables", ["seats"], name: "index_tables_on_seats"

end
