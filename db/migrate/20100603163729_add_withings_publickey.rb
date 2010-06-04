class AddWithingsPublickey < ActiveRecord::Migration
  def self.up
    add_column :people, :withings_publickey, :string,
  end

  def self.down
    remove_column :people, :withings_publickey
  end
end
