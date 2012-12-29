class AddAvailableSettlements < ActiveRecord::Migration
  def change
    add_column :seats, :settlement0_id, :integer, :default => nil
    add_column :seats, :settlement1_id, :integer, :default => nil
    add_column :seats, :settlement2_id, :integer, :default => nil
    add_column :seats, :settlement3_id, :integer, :default => nil
    add_column :seats, :settlement4_id, :integer, :default => nil
    add_column :seats, :settlement5_id, :integer, :default => nil
    add_column :seats, :settlement6_id, :integer, :default => nil
    add_column :seats, :settlement7_id, :integer, :default => nil

    add_index :seats, [:settlement0_id, :settlement1_id]
    add_index :seats, [:settlement2_id, :settlement3_id]
    add_index :seats, [:settlement4_id, :settlement5_id]
    add_index :seats, [:settlement6_id, :settlement7_id]
  end
end
