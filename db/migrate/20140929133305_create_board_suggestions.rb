class CreateBoardSuggestions < ActiveRecord::Migration
  def change
    create_table :board_suggestions do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.string :suggestion
      t.timestamps
    end
  end
end
