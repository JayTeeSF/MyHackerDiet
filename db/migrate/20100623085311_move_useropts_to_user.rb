class MoveUseroptsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :dob, :date
    add_column :users, :sex, :string
    add_column :users, :height, :integer
    add_column :users, :withings_userid, :string
    add_column :users, :withings_publickey, :string

    drop_table :user_options
  end

  def self.down
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
end
