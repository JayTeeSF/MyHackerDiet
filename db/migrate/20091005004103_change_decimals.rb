class ChangeDecimals < ActiveRecord::Migration
  def self.up
    remove_column :weights, :weight
    add_column :weights, :weight, :decimal, :precision=>12, :scale=>2
  end

  def self.down
    remove_column :weights, :weight
    add_column :weights, :weight, :decimal
  end
end
