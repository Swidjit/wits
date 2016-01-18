class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.integer :user_id, :null=>:false
      t.integer :game_id, :null=>:false
      t.float :pct

      t.integer :score
      t.integer :board_count
      t.float :score_avg
      t.timestamps
    end
  end
end
