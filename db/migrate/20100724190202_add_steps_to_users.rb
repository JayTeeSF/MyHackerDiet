class AddStepsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :steps, :boolean
  end

  def self.down
    remove_column :users, :steps
  end
end
