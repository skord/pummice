class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, :default => 'Central Time (US & Canada), (GMT-06:00)'
  end
end
