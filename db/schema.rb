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

ActiveRecord::Schema.define(version: 20150514075108) do

  create_table "cities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "region",       limit: 255
    t.string   "airport_code", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "favorite",     limit: 1
  end

  create_table "fares", force: :cascade do |t|
    t.decimal  "price",                        precision: 8, scale: 2
    t.date     "departure_date"
    t.integer  "origin_id",      limit: 4
    t.integer  "destination_id", limit: 4
    t.text     "comments",       limit: 65535
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "fares", ["destination_id"], name: "index_fares_on_destination_id", using: :btree
  add_index "fares", ["origin_id"], name: "index_fares_on_origin_id", using: :btree

  create_table "lead_time_fares", force: :cascade do |t|
    t.integer "origin_id",      limit: 4
    t.integer "destination_id", limit: 4
    t.date    "departure_date"
    t.decimal "price",                    precision: 8, scale: 2
    t.integer "lead_days",      limit: 4
  end

  add_index "lead_time_fares", ["destination_id"], name: "index_lead_time_fares_on_destination_id", using: :btree
  add_index "lead_time_fares", ["origin_id"], name: "index_lead_time_fares_on_origin_id", using: :btree

  create_table "low_fares", force: :cascade do |t|
    t.integer  "origin_id",       limit: 4
    t.integer  "destination_id",  limit: 4
    t.decimal  "price",                         precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.text     "departure_dates", limit: 65535
    t.decimal  "departure_price",               precision: 8, scale: 2, default: 0.0
    t.text     "return_dates",    limit: 65535
    t.decimal  "return_price",                  precision: 8, scale: 2, default: 0.0
    t.text     "url",             limit: 65535
    t.datetime "last_checked"
  end

  add_index "low_fares", ["destination_id"], name: "index_low_fares_on_destination_id", using: :btree
  add_index "low_fares", ["origin_id"], name: "index_low_fares_on_origin_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree
  add_index "roles", ["resource_id", "resource_type"], name: "index_roles_on_resource_id_and_resource_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
