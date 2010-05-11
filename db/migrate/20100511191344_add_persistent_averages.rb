class AddPersistentAverages < ActiveRecord::Migration
  def self.up
    add_column :weights, 'avg_weight', :decimal
  end

  def self.down
    remove_column :weights, 'avg_weight'
  end
end
