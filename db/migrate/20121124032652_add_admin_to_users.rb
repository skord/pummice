class AddAdminToUsers < ActiveRecord::Migration
	def self.up
		add_column :users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :admin
  end

  def change
    add_column :users, :admin, :boolean
  end
end
