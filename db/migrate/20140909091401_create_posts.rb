class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.belongs_to :game_board
      t.string :body
      t.integer :importance, :default=>0
      t.string :slug
      t.boolean :active
      t.string :status, :default => 'draft'
      t.integer :score, :default => 0
      t.timestamps
    end
  end
end
