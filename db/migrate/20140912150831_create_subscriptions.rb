class CreateSubscriptions < ActiveRecord::Migration
 def change
    create_table :subscriptions do |t|
      t.integer :subscription_id, :null => false
      t.string :subscription_type, :null => false
      t.belongs_to :user
      t.timestamps
    end
 end
end
