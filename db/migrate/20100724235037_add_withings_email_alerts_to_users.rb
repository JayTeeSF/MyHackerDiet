class AddWithingsEmailAlertsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :withings_email_alerts, :boolean
  end

  def self.down
    remove_column :users, :withings_email_alerts
  end
end
