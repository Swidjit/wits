class CreateGameBoards < ActiveRecord::Migration
  def change
    create_table :game_boards do |t|
      t.belongs_to :game
      t.text :content
      t.integer :duration
      t.datetime :start_date
      t.string :status, :default => "queued"
      t.string :data
      t.datetime :end_date
      t.timestamps
    end
  end
end
