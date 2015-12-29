class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :notifier_id
      t.string :notifier_type
      t.string :notifier_action
      t.boolean :delivered, :default => false
      t.boolean :read, :default => false
      t.timestamps
    end
  end
end
