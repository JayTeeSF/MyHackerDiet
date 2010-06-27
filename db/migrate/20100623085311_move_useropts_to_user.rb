class MoveUseroptsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :dob, :date
    add_column :users, :sex, :string
    add_column :users, :height, :integer
    add_column :users, :withings_userid, :string
    add_column :users, :withings_publickey, :string
  end

  def self.down
    remove_column :users, :dob
    remove_column :users, :sex
    remove_column :users, :height
    remove_column :users, :withings_userid
    remove_column :users, :withings_publickey
  end

end
