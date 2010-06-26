class RemovePeople < ActiveRecord::Migration
  def self.up
    drop_table :people
  end

  def self.down
    create_table :people do |t|
      t.string   "name"
      t.string   "salt"
      t.string   "encrypted_password"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "sex"
      t.integer  "height"
      t.date     "dob"
      t.integer  "withings_uid"
      t.string   "withings_publickey"
      t.string   "email"
    end

  end
end
