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

ActiveRecord::Schema.define(version: 20150922053820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "agent_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "license_number"
    t.string   "phone_number"
    t.string   "dropbox_session"
    t.string   "account_number"
    t.boolean  "is_admin",               default: false
    t.boolean  "designated_individual",  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "sub_brokerage_id"
    t.integer  "brokerage_id"
  end

  add_index "agents", ["brokerage_id"], name: "index_agents_on_brokerage_id", using: :btree
  add_index "agents", ["confirmation_token"], name: "index_agents_on_confirmation_token", unique: true, using: :btree
  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree
  add_index "agents", ["sub_brokerage_id"], name: "index_agents_on_sub_brokerage_id", using: :btree

  create_table "brokerages", force: :cascade do |t|
    t.string   "name"
    t.string   "postal_code"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "agent_id"
    t.integer  "taxpayer_id"
    t.string   "status"
    t.string   "pdf_path"
    t.string   "docusign_url"
    t.string   "purchased_at"
    t.string   "transaction_id"
    t.text     "notification_params"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "order_number"
    t.string   "dropbox_url"
    t.string   "order_type"
    t.string   "payment_method"
    t.string   "payment_confirmation_number"
  end

  add_index "orders", ["agent_id"], name: "index_orders_on_agent_id", using: :btree
  add_index "orders", ["taxpayer_id"], name: "index_orders_on_taxpayer_id", using: :btree

  create_table "sub_brokerages", force: :cascade do |t|
    t.string   "name"
    t.string   "postal_code"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "phone_number"
    t.integer  "brokerage_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "sub_brokerages", ["brokerage_id"], name: "index_sub_brokerages_on_brokerage_id", using: :btree

  create_table "taxpayers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sin"
    t.string   "dob"
    t.string   "email"
    t.string   "phone_number"
    t.string   "pdf_path"
    t.integer  "agent_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "taxpayers", ["agent_id"], name: "index_taxpayers_on_agent_id", using: :btree

end
