class AddManualToWeights < ActiveRecord::Migration
  def self.up
    add_column :weights, :manual, :boolean, :default => 1
  end

  def self.down
    remove_column :weights, :manual
  end
end
