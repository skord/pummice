class RelateBuildingCardToUserAndGame < ActiveRecord::Migration
  def change
    add_column :seats, :tile00_id, :integer, :default => nil
    add_column :seats, :tile10_id, :integer, :default => nil
    add_column :seats, :tile01_id, :integer, :default => nil
    add_column :seats, :tile11_id, :integer, :default => nil
    add_column :seats, :tile02_id, :integer, :default => nil
    add_column :seats, :tile12_id, :integer, :default => nil
    add_column :seats, :tile03_id, :integer, :default => nil
    add_column :seats, :tile13_id, :integer, :default => nil
    add_column :seats, :tile04_id, :integer, :default => nil
    add_column :seats, :tile14_id, :integer, :default => nil

    add_index :seats, [:tile00_id, :tile10_id]
    add_index :seats, [:tile01_id, :tile11_id]
    add_index :seats, [:tile02_id, :tile12_id]
    add_index :seats, [:tile03_id, :tile13_id]
    add_index :seats, [:tile04_id, :tile14_id]
  end
end
