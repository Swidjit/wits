class AddContentLimitToGameBoards < ActiveRecord::Migration
  def change
    add_column :game_boards, :content_limit, :integer
    add_column :games, :content_limit, :integer
  end
end
