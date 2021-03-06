class CreateWithings < ActiveRecord::Migration
  def self.up
    create_table :withings do |t|
      t.integer :userid
      t.datetime :rec_date
      t.decimal :weight, :precision => 12, :scale => 2
      t.decimal :bodyfat, :precision => 12, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :withings
  end
end
