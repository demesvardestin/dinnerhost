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

ActiveRecord::Schema.define(version: 20190101003010) do

  create_table "app_errors", force: :cascade do |t|
    t.string   "error_type"
    t.text     "details"
    t.boolean  "resolved",    default: false
    t.string   "object_type"
    t.integer  "object_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "chef_ratings", force: :cascade do |t|
    t.integer  "value"
    t.integer  "chef_id"
    t.integer  "customer_id"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "chefs", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "pinterest"
    t.text     "bio"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
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
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "image"
    t.boolean  "verified",               default: false
    t.string   "education",              default: "N/A"
    t.string   "languages",              default: "English"
    t.string   "government_id",          default: ""
    t.integer  "referral_id"
    t.boolean  "live",                   default: false
    t.string   "shortened_url"
    t.boolean  "has_stripe_account",     default: false
    t.string   "stripe_token"
    t.boolean  "deleted",                default: false
    t.string   "license",                default: "none"
    t.string   "stripe_bank_token"
    t.boolean  "suspended",              default: false
    t.datetime "accepted_guidelines_on"
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

  create_table "cook_reports", force: :cascade do |t|
    t.string   "report_type"
    t.text     "details"
    t.integer  "chef_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "email",                  default: "",                      null: false
    t.string   "encrypted_password",     default: "",                      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "user_type",              default: "customer"
    t.integer  "sign_in_count",          default: 0,                       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "image",                  default: "/images/no_avatar.png"
    t.string   "street_address",         default: ""
    t.string   "town",                   default: ""
    t.string   "state",                  default: ""
    t.string   "zipcode",                default: ""
    t.float    "latitude"
    t.float    "longitude"
    t.string   "government_id",          default: ""
    t.string   "facebook",               default: ""
    t.string   "instagram",              default: ""
    t.string   "twitter",                default: ""
    t.text     "bio",                    default: ""
    t.float    "credit_value",           default: 0.0
    t.string   "referral_code"
    t.boolean  "has_stripe_account",     default: false
    t.string   "stripe_token"
    t.string   "stripe_last_4"
    t.string   "card_brand"
    t.boolean  "deleted",                default: false
    t.boolean  "suspended",              default: false
    t.datetime "accepted_guidelines_on"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "diner_ratings", force: :cascade do |t|
    t.float    "value"
    t.integer  "customer_id"
    t.integer  "chef_id"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "quantity"
    t.text     "additional_details"
    t.integer  "chef_id"
    t.integer  "meal_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "meal_ratings", force: :cascade do |t|
    t.integer  "value"
    t.integer  "meal_id"
    t.integer  "customer_id"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "meal_reports", force: :cascade do |t|
    t.string   "report_type"
    t.text     "details"
    t.integer  "meal_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "meals", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "host_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "street_address"
    t.string   "town"
    t.string   "state"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "meal_type"
    t.integer  "chef_id"
    t.string   "prep_fee",            default: "0.00"
    t.string   "image",               default: ""
    t.string   "serving_temperature", default: ""
    t.string   "allergens",           default: ""
    t.string   "dish_order",          default: ""
    t.string   "tags",                default: ""
    t.string   "course",              default: ""
    t.string   "flavor",              default: ""
    t.boolean  "deleted",             default: false
    t.text     "notable_ingredients"
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

  create_table "referrals", force: :cascade do |t|
    t.integer  "referrer_id"
    t.string   "referrer_type"
    t.string   "code_value",    default: ""
    t.boolean  "applied",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "reservation_cancellations", force: :cascade do |t|
    t.text     "reason"
    t.boolean  "approved",       default: false
    t.datetime "approved_on"
    t.datetime "denied_on"
    t.integer  "customer_id"
    t.integer  "reservation_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "reservation_id"
    t.string   "fee",                default: "0.00"
    t.datetime "made_on",            default: '2018-11-13 03:51:55'
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "meal_id"
    t.string   "charge_id"
    t.string   "start_date",         default: ""
    t.string   "end_date",           default: ""
    t.integer  "adult_count",        default: 0
    t.integer  "children_count",     default: 0
    t.string   "allergies"
    t.string   "meal_ids"
    t.string   "request_date"
    t.integer  "chef_id"
    t.text     "additional_message"
    t.boolean  "active",             default: false
    t.boolean  "accepted"
    t.datetime "accepted_on"
    t.datetime "denied_on"
    t.string   "request_time",       default: ""
    t.boolean  "deleted",            default: false
    t.boolean  "cancelled",          default: false
    t.datetime "cancelled_on"
    t.boolean  "completed",          default: false
    t.string   "token"
    t.boolean  "diner_alerted",      default: false
    t.datetime "diner_alerted_on"
    t.integer  "diner_alerts_sent",  default: 0
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "conversation_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "wishlists", force: :cascade do |t|
    t.integer  "meal_id"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
