class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.integer :board_id
      t.string :award_type
      t.timestamps
    end
  end
end
