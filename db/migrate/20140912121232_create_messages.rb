class CreateMessages < ActiveRecord::Migration
 def change
    create_table :messages do |t|
      t.string :body
      t.belongs_to :user
      t.belongs_to :conversation
      t.timestamps
    end
 end
end

