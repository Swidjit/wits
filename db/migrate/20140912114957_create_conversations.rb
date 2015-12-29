class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.belongs_to :user
      t.integer :recipient_id
      t.timestamps
    end
  end
end