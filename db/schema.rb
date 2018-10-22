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

ActiveRecord::Schema.define(version: 20181021225407) do

  create_table "admins", force: :cascade do |t|
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "profile_image",          default: ""
    t.string   "email",                  default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.text     "bio"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title",        default: ""
    t.text     "content",      default: ""
    t.string   "author",       default: ""
    t.string   "tags",         default: ""
    t.integer  "admin_id"
    t.string   "banner_image", default: "https://s3.us-east-2.amazonaws.com/senzzu/stores_banner.png"
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.string   "category"
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "item_count",        default: 0
    t.string   "shopper_email",     default: ""
    t.string   "total_cost",        default: ""
    t.boolean  "pending",           default: false
    t.boolean  "completed",         default: false
    t.string   "item_list",         default: ""
    t.string   "item_list_count",   default: ""
    t.string   "instructions_list", default: ""
    t.integer  "order_id"
    t.integer  "store_id"
    t.string   "final_amount",      default: ""
    t.boolean  "paid",              default: false
    t.string   "current_location",  default: ""
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "shopper_id",        default: ""
    t.string   "items_price_list",  default: ""
    t.string   "item_list_name",    default: ""
    t.string   "item_tax_list",     default: ""
  end

  create_table "favorites_logs", force: :cascade do |t|
    t.integer  "store_id"
    t.string   "shopper_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string   "email"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "store_id"
    t.string   "shopper_email",         default: ""
    t.boolean  "guest",                 default: false
    t.string   "item_list",             default: ""
    t.string   "item_list_count",       default: ""
    t.string   "total",                 default: ""
    t.string   "stripe_charge_id",      default: ""
    t.string   "confirmation",          default: ""
    t.string   "address",               default: ""
    t.string   "phone_number",          default: ""
    t.integer  "apartment_number"
    t.datetime "ordered_at"
    t.boolean  "online",                default: true
    t.boolean  "delivered",             default: false
    t.boolean  "processed",             default: false
    t.string   "status",                default: ""
    t.string   "delivery_email",        default: ""
    t.string   "delivery_option",       default: ""
    t.string   "shopper_uid",           default: ""
    t.string   "delivery_day",          default: ""
    t.string   "delivery_time",         default: ""
    t.string   "delivery_instructions", default: ""
    t.string   "details",               default: ""
    t.string   "order_type",            default: ""
    t.string   "contact_name",          default: ""
    t.string   "pickup_time",           default: ""
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "payment_type",          default: "paid online"
  end

  create_table "past_orders", force: :cascade do |t|
    t.string   "total"
    t.string   "details"
    t.string   "order_type"
    t.string   "status"
    t.string   "additional_details"
    t.string   "confirmation"
    t.string   "delivery_address"
    t.string   "delivery_phone"
    t.string   "delivery_name"
    t.string   "pickup_contact"
    t.string   "pickup_time"
    t.integer  "store_id"
    t.string   "shopper_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "customer_email"
  end

  create_table "registration_requests", force: :cascade do |t|
    t.string   "store_name"
    t.string   "store_address"
    t.string   "store_manager"
    t.string   "store_phone"
    t.string   "store_email"
    t.string   "store_website"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "category",      default: ""
    t.string   "token"
    t.string   "url"
  end

  create_table "shoppers", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean  "guest",                  default: false
    t.index ["email"], name: "index_shoppers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_shoppers_on_reset_password_token", unique: true
  end

  create_table "special_orders", force: :cascade do |t|
    t.string   "item_name"
    t.string   "item_size"
    t.string   "item_description"
    t.string   "item_price"
    t.string   "availability_date"
    t.integer  "store_id"
    t.string   "shopper_phone",     default: ""
    t.boolean  "pending",           default: false
    t.boolean  "denied",            default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "picked_up",         default: false
  end

  create_table "store_reviews", force: :cascade do |t|
    t.string   "content"
    t.integer  "store_id"
    t.string   "author"
    t.string   "shopper_id"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at",                                                                                          null: false
    t.datetime "updated_at",                                                                                          null: false
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
    t.string   "opening_weekday",        default: "9:00AM"
    t.string   "closing_weekday",        default: "9:00PM"
    t.string   "opening_saturday",       default: "9:00AM"
    t.string   "closing_saturday",       default: "9:00PM"
    t.string   "opening_sunday",         default: "9:00AM"
    t.string   "closing_sunday",         default: "9:00PM"
    t.string   "email",                  default: "",                                                                 null: false
    t.string   "encrypted_password",     default: "",                                                                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sessions_count",         default: 1
    t.string   "token_id",               default: ""
    t.string   "firestore_doc_id"
    t.boolean  "firebase_initialized",   default: false
    t.string   "category",               default: ""
    t.string   "delivery_fee",           default: "0.00"
    t.string   "banner_image",           default: "https://s3.us-east-2.amazonaws.com/senzzu/store_login_banner.png"
    t.string   "delivery_minimum",       default: "10.00"
    t.index ["email"], name: "index_stores_on_email", unique: true
    t.index ["reset_password_token"], name: "index_stores_on_reset_password_token", unique: true
  end

  create_table "stripe_alerts", force: :cascade do |t|
    t.string   "account"
    t.string   "event_type"
    t.string   "authorization"
    t.string   "event_id"
    t.string   "disabled_reasons"
    t.integer  "due_by"
    t.string   "fields_needed"
    t.string   "destination"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
