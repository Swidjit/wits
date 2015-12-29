class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.string :description
      t.float :rating
      t.integer :times_played
      t.integer :board_count
      t.string :logo_url
      # ... more column fields #
      t.timestamps
    end
  end
end
