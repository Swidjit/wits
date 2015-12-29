class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation

  validates_presence_of :conversation, :user, :body


  after_save :update_familiarity

  def search_excerpt(term)
    spot = self.body.index(term)
    start_spot = spot - 25;
    start_spot = start_spot > 0 ? start_spot : 0
    end_spot = spot + term.length + 25
    end_spot = end_spot > self.body.length ? self.body.length : end_spot
    str = self.body[start_spot..end_spot]
    str = "..."+str if start_spot > 0
    str = str+"..." if end_spot < self.body.length
    return str

  end

  def update_familiarity



  end



end
