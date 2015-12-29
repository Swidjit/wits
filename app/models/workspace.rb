class Workspace < ActiveRecord::Base
  validates_presence_of :game_board_id, :user_id

  belongs_to :user
end
