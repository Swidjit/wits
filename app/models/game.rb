class Game < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :game_boards, :dependent => :delete_all
  has_many :votes,:as => :voteable, :dependent => :delete_all
  has_many :board_suggestions, :dependent => :delete_all
  has_many :game_improvements, :dependent => :delete_all

  acts_as_commentable

  def active_game
    self.game_boards.where(:status => "active").first
  end
end
