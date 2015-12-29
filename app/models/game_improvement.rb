class GameImprovement < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  has_many :votes,:as => :voteable, :dependent => :delete_all

end
