class GameBoard < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :game
  has_many :players, :foreign_key => 'user_id', :class_name => "User"
  has_many :posts, :dependent => :delete_all
  has_many :votes,:as => :voteable, :dependent => :delete_all

  # has_many :results

  serialize :content



  scope :active, lambda{ where("#{table_name}.status = ?","active")}
  scope :expired, lambda{ where("#{table_name}.status = ?", "expired")}



end
