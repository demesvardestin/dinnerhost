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

ActiveRecord::Schema.define(version: 20181115140551) do

  create_table "chefs", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "pinterest"
    t.text     "bio"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "street_address"
    t.string   "town"
    t.string   "state"
    t.string   "zipcode"
    t.string   "booking_rate"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "user_type",              default: "chef"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_chefs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_chefs_on_reset_password_token", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "chef_id"
    t.integer  "customer_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "last_accessed"
    t.string   "archived_by",                default: ""
    t.string   "last_accessed_by_user_type"
    t.integer  "last_accessed_by_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "user_type",              default: "customer"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "meals", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "host_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "street_address"
    t.string   "town"
    t.string   "state"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "meal_type"
    t.integer  "chef_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "conversation_id"
    t.integer  "chef_id"
    t.integer  "customer_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "sender_type"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "reservation_id"
    t.string   "fee",            default: "0.00"
    t.datetime "made_on",        default: '2018-11-13 03:51:55'
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "meal_id"
    t.string   "charge_id"
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "conversation_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
