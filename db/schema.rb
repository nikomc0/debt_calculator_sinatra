# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_04_130852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "account_name"
    t.decimal "principal", precision: 10, scale: 2
    t.decimal "apr", precision: 13, scale: 9
    t.integer "due_date"
    t.boolean "paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.decimal "monthly_interest", precision: 13, scale: 9
    t.decimal "monthly_payment", precision: 10, scale: 2
    t.integer "num_months"
    t.datetime "month"
    t.decimal "min_payment", precision: 10, scale: 2
    t.index ["account_id"], name: "index_accounts_on_account_id"
  end

  create_table "paid_payments", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "payment", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "month"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "payment", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "month"
    t.decimal "balance", precision: 10, scale: 2
    t.boolean "paid", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "user_name", null: false
    t.decimal "monthly_budget", precision: 10, scale: 2
    t.string "password_hash", null: false
    t.boolean "user", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
