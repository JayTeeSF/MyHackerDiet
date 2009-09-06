class AddBodyFatToWeight < ActiveRecord::Migration
  def self.up
    add_column :weights, :bodyfat, :decimal
  end

  def self.down
    remove_column :weights, :bodyfat
  end
end
