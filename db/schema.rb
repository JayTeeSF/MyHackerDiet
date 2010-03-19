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

ActiveRecord::Schema.define(:version => 20100319002144) do

  create_table "eppas", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "salt",                              :null => false
    t.string   "encrypted_password",                :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "age",                               :null => false
    t.string   "sex",                :limit => nil, :null => false
    t.integer  "height",                            :null => false
  end

  create_table "sessions", :force => true do |t|
    t.integer  "person_id",  :null => false
    t.string   "ip_address", :null => false
    t.string   "path",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "steps", :force => true do |t|
    t.date     "rec_date",   :null => false
    t.integer  "steps",      :null => false
    t.integer  "mod_steps",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "mod_min",    :null => false
    t.integer  "person_id",  :null => false
  end

  create_table "weights", :force => true do |t|
    t.date     "rec_date",                                  :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "person_id",                                 :null => false
    t.decimal  "weight",     :precision => 12, :scale => 2, :null => false
    t.decimal  "bodyfat",    :precision => 2,  :scale => 2, :null => false
  end

end
