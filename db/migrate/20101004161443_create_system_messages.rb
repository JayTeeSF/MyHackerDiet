class CreateSystemMessages < ActiveRecord::Migration
  
  def self.up
    create_table :system_messages do |t|
      t.string        :header
      t.string        :level
      t.text          :message
      t.boolean       :dismissed, :default => false
      t.boolean       :dismissable, :default => false
      t.datetime      :expires
      t.references    :messageable, :polymorphic => true  
      t.timestamps   
    end

    add_index :system_messages, [:dismissed, :expires], :name => 'viewable_index'
    add_index :system_messages, [:messageable_type, :messageable_id], :name => 'messageable'

  end
  
  def self.down
    drop_table :system_messages    
  end
  
end
