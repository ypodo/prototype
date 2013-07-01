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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130701112931) do

  create_table "audio_files", :force => true do |t|
    t.integer  "user_id"
    t.string   "audio_hash"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "index"
    t.string   "create"
    t.string   "destroy"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invite_histories", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "number"
    t.integer  "user_id"
    t.string   "event"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "arriving"
    t.string   "token"
  end

  create_table "invites", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arriving"
  end

  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "locations", :force => true do |t|
    t.string   "gpsLatitude"
    t.string   "gpsLongitude"
    t.string   "addres"
    t.string   "link"
    t.integer  "user_id"
    t.string   "token"
    t.integer  "event_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.decimal  "amount"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "status"
  end

  create_table "phones", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "phone"
    t.boolean  "returned"
    t.string   "user"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.boolean  "agreement"
    t.string   "provider"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "category"
    t.string   "language"
  end

end
