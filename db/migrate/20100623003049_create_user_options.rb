class CreateUserOptions < ActiveRecord::Migration
  def self.up
    create_table :user_options do |t|
      t.integer :user_id
      t.string :name
      t.date :dob
      t.integer :height
      t.string :sex
      t.string :withings_userid
      t.string :withings_publickey

      t.timestamps
    end
  end

  def self.down
    drop_table :user_options
  end
end
