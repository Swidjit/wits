class BoardSuggestion < ActiveRecord::Base

  has_many :votes,:as => :voteable, :dependent => :delete_all
end
