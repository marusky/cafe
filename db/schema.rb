# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_10_04_145806) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "customers" because of following StandardError
#   Unknown type 'uuid' for column 'id'


  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price", default: 0, null: false
    t.integer "discount_price"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

# Could not dump table "push_subscriptions" because of following StandardError
#   Unknown type 'uuid' for column 'customer_id'


  add_foreign_key "products", "categories"
  add_foreign_key "push_subscriptions", "customers"
end
