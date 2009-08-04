class ModifyStepsAddModDur < ActiveRecord::Migration
  def self.up
	  add_column :steps, :mod_min, :integer
  end

  def self.down
	  remove_column :steps, :mod_min
  end
end
