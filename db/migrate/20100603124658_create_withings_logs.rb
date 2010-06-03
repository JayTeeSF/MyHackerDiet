class CreateWithingsLogs < ActiveRecord::Migration
  def self.up
    create_table :withings_logs do |t|
      t.integer 'userid'
      t.datetime 'sdate'
      t.datetime 'edate'

      t.timestamps
    end
  end

  def self.down
    drop_table :withings_logs
  end
end
