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

ActiveRecord::Schema.define(version: 20180905141708) do

  create_table "registration_requests", force: :cascade do |t|
    t.string   "store_name"
    t.string   "store_address"
    t.string   "store_manager"
    t.string   "store_phone"
    t.string   "store_email"
    t.string   "store_website"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name",                   default: ""
    t.string   "street_address",         default: ""
    t.string   "town",                   default: ""
    t.string   "state",                  default: ""
    t.string   "zipcode",                default: ""
    t.string   "stripe_cus",             default: ""
    t.boolean  "active",                 default: true
    t.boolean  "live",                   default: false
    t.boolean  "stripe_connected",       default: false
    t.string   "npi",                    default: ""
    t.string   "website",                default: ""
    t.string   "phone",                  default: ""
    t.string   "supervisor",             default: ""
    t.boolean  "receives_push",          default: false
    t.string   "push_endpoint",          default: ""
    t.string   "sub_auth",               default: ""
    t.string   "p256dh",                 default: ""
    t.float    "latitude",               default: 0.0
    t.float    "longitude",              default: 0.0
    t.boolean  "on_trial",               default: true
    t.string   "opening_weekday",        default: ""
    t.string   "closing_weekday",        default: ""
    t.string   "opening_saturday",       default: ""
    t.string   "closing_saturday",       default: ""
    t.string   "opening_sunday",         default: ""
    t.string   "closing_sunday",         default: ""
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sessions_count",         default: 1
    t.string   "token_id",               default: ""
    t.index ["email"], name: "index_stores_on_email", unique: true
    t.index ["reset_password_token"], name: "index_stores_on_reset_password_token", unique: true
  end

end
