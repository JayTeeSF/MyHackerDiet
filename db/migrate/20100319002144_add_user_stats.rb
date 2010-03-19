class AddUserStats < ActiveRecord::Migration
  def self.up
    add_column :people, :age,    :integer
    add_column :people, :sex,    :char
    add_column :people, :height, :integer
  end

  def self.down
    remove_column :people, :age
    remove_column :people, :sex
    remove_column :people, :height
  end
end
