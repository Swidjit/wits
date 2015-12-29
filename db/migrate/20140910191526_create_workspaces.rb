class CreateWorkspaces < ActiveRecord::Migration
  def change
    create_table :workspaces do |t|
      t.string :body
      t.integer :game_board_id
      t.belongs_to :user
      t.timestamps
    end
  end
end
