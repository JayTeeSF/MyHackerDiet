class Weights < ActiveRecord::Migration
  def self.up
    add_column :weights, :person_id, :integer
  end

  def self.down
    remove_column :weights, :person_id, :integer
  end
end
