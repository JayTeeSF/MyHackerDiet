class AddWithingsPublickey < ActiveRecord::Migration
  def self.up
    add_column :people, :withings_publickey, :integer,
  end

  def self.down
    remove_column :people, :withings_publickey
  end
end
