class Steps < ActiveRecord::Migration
  def self.up
    add_column :steps, :person_id, :integer
  end

  def self.down
    remove_column :steps, :person_id, :integer
  end
end
