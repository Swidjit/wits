class CreateFamiliarty < ActiveRecord::Migration
  def change
    create_table :familiarities do |t|
      t.references :user, :null => false
      t.integer :familiar_id, :null => false
      t.integer :familiarness, :null => false, :default => 0
    end

    add_index :familiarities, [:user_id, :familiar_id], :unique => true
  end
end
