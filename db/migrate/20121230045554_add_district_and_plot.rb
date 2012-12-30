class AddDistrictAndPlot < ActiveRecord::Migration
  def up
    create_table :districts do |t|
      t.references :districtable, :polymorphic => true
      t.integer :cost
      t.integer :side
      t.integer :position_x
      t.integer :position_y
      t.integer :tile0_id, :default => nil
      t.integer :tile1_id, :default => nil
      t.integer :tile2_id, :default => nil
      t.integer :tile3_id, :default => nil
      t.integer :tile4_id, :default => nil
      t.integer :tile0_type
      t.integer :tile1_type
      t.integer :tile2_type
      t.integer :tile3_type
      t.integer :tile4_type
    end

    add_index :districts, [:tile0_id]
    add_index :districts, [:tile1_id]
    add_index :districts, [:tile2_id]
    add_index :districts, [:tile3_id]
    add_index :districts, [:tile4_id]

    create_table :plots do |t|
      t.references :plotable, :polymorphic => true
      t.integer :cost
      t.integer :side
      t.integer :position_x
      t.integer :position_y
      t.integer :tile00_id, :default => nil
      t.integer :tile10_id, :default => nil
      t.integer :tile01_id, :default => nil
      t.integer :tile11_id, :default => nil
      t.integer :tile00_type
      t.integer :tile10_type
      t.integer :tile01_type
      t.integer :tile11_type
    end

    add_index :plots, [:tile00_id]
    add_index :plots, [:tile10_id]
    add_index :plots, [:tile01_id]
    add_index :plots, [:tile11_id]
  end

  def down
    drop_table :districts
    drop_table :plots
  end
end
