class TieUserToWithings < ActiveRecord::Migration
  def self.up
    add_column :people, :withings_uid, :integer
  end

  def self.down
    remove_column :people, :withings_uid
  end
end
