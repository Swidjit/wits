class CreateGameImprovements < ActiveRecord::Migration
  def change
    create_table :game_improvements do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.string :improvement
      t.timestamps
    end
  end
end
