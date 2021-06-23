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

ActiveRecord::Schema.define(version: 2021_06_22_144556) do

  create_table "areas", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "city_number"
    t.bigint "prefecture_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "offices", charset: "utf8mb4", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "password"
    t.string "name"
    t.string "title"
    t.string "postcode"
    t.string "address"
    t.string "near_station"
    t.string "tel"
    t.string "fax"
    t.string "email"
    t.string "company"
    t.text "url"
    t.text "introduction"
    t.float "latitude"
    t.float "longitude"
    t.integer "city_id"
    t.string "staff_number"
    t.string "city_number"
    t.boolean "status"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prefectures", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.bigint "area_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["area_id"], name: "index_prefectures_on_area_id"
  end

  add_foreign_key "prefectures", "areas"
end
