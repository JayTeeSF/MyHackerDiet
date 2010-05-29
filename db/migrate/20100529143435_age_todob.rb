class AgeTodob < ActiveRecord::Migration
  def self.up
    add_column :people, :dob, :date
    remove_column :people, :age
  end

  def self.down
    remove_column :people, :dob
    add_column :people, :age, :integer
  end
end
