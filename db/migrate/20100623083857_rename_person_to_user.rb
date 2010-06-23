class RenamePersonToUser < ActiveRecord::Migration
  def self.up
    rename_column :weights, :person_id, :user_id
    rename_column :steps, :person_id, :user_id
  end

  def self.down
  end
end
