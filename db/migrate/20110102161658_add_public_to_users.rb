class AddPublicToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :public, :boolean
    add_column :users, :public_id, :string

    add_index :users, ["public_id"], :name => 'index_users_on_public_id', :unique => true
    
    # Update all users with a public_id
    User.all.each do |u|
      u.save
    end
  end

  def self.down
    remove_column :users, :public
    remove_column :users, :public_id
  end

end
