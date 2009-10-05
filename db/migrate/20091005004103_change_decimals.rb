class ChangeDecimals < ActiveRecord::Migration
  def self.up
    remove_column :weights, :weight
    remove_column :weights, :bodyfat
    add_column :weights, :weight, :decimal, :precision=>12, :scale=>2
    add_column :weights, :bodyfat, :decimal, :precision=>4, :scale=>2
  end

  def self.down
    remove_column :weights, :weight
    remove_column :weights, :bodyfat
    add_column :weights, :weight, :decimal
    add_column :weights, :bodyfat, :decimal
  end
end
