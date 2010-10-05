# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101004161443) do

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.integer  "person_id"
    t.string   "ip_address"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", :force => true do |t|
    t.date     "rec_date"
    t.integer  "steps"
    t.integer  "mod_steps"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mod_min"
    t.integer  "user_id"
  end

  create_table "system_messages", :force => true do |t|
    t.string   "header"
    t.string   "level"
    t.text     "message"
    t.boolean  "dismissed",        :default => false
    t.boolean  "dismissable",      :default => false
    t.datetime "expires"
    t.integer  "messageable_id"
    t.string   "messageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_messages", ["dismissed", "expires"], :name => "viewable_index"
  add_index "system_messages", ["messageable_type", "messageable_id"], :name => "messageable"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "", :null => false
    t.string   "password_salt",                        :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "dob"
    t.string   "sex"
    t.integer  "height"
    t.string   "withings_userid"
    t.string   "withings_publickey"
    t.boolean  "steps"
    t.boolean  "withings_email_alerts"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weights", :force => true do |t|
    t.date     "rec_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "weight",     :precision => 12, :scale => 2
    t.decimal  "bodyfat",    :precision => 4,  :scale => 2
    t.decimal  "avg_weight", :precision => 12, :scale => 2
    t.integer  "rec_type"
  end

  create_table "withings", :force => true do |t|
    t.integer  "userid"
    t.datetime "rec_date"
    t.decimal  "weight",     :precision => 12, :scale => 2
    t.decimal  "bodyfat",    :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withings_logs", :force => true do |t|
    t.integer  "userid"
    t.datetime "sdate"
    t.datetime "edate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
