class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user
      t.belongs_to :category
      t.string :resource_type
      t.string :resource_id
      t.integer :importance, :default=>0
      t.string :title
      t.text :body
      t.string :slug
      t.timestamps
    end
  end
end
