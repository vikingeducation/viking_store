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

ActiveRecord::Schema.define(version: 20161130004745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street",       null: false
    t.string   "zip",          null: false
    t.boolean  "primary",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "users_id"
    t.string   "city",         null: false
    t.string   "state",        null: false
    t.string   "country",      null: false
    t.string   "address_type"
    t.index ["users_id"], name: "index_addresses_on_users_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "quantity",    null: false
    t.float    "sale_price",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "products_id"
    t.integer  "orders_id"
    t.index ["orders_id"], name: "index_line_items_on_orders_id", using: :btree
    t.index ["products_id"], name: "index_line_items_on_products_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "date",       null: false
    t.boolean  "open",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "users_id"
    t.index ["users_id"], name: "index_orders_on_users_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",         null: false
    t.text     "description",   null: false
    t.float    "price",         null: false
    t.string   "sku",           null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "categories_id"
    t.index ["categories_id"], name: "index_products_on_categories_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "first_name",   null: false
    t.string   "last_name",    null: false
    t.string   "email",        null: false
    t.string   "phone_number"
    t.index ["id"], name: "index_users_on_id", unique: true, using: :btree
  end

  add_foreign_key "addresses", "users", column: "users_id"
  add_foreign_key "line_items", "orders", column: "orders_id"
  add_foreign_key "line_items", "products", column: "products_id"
  add_foreign_key "orders", "users", column: "users_id"
  add_foreign_key "products", "categories", column: "categories_id"
end
