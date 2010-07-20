class RenameManualToRecType < ActiveRecord::Migration
  def self.up
    remove_column :weights, :manual
    add_column :weights, :rec_type, :integer
  end

  def self.down
    remove_column :weights, :rec_type
    add_column :weights, :manual, :boolean
  end
end
