class FlagVote < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :post

  validates_uniqueness_of :user_id, scope: :post_id

  after_save :check_flag_status

  scope :yes, lambda { FlagVote.where("vote = 'yes'") }
  scope :no, lambda { FlagVote.where("vote = 'no'") }

  def check_flag_status
    post = Post.unscoped.find(self.post_id)
    if post.flag_votes.size >= 10
      if post.flag_votes.yes.size >= 7
        post.update_attribute(:status, 'active')
      end
    elsif post.flag_votes.no.size > 4
      post.update_attribute(:status, 'banned')
    end
  end

end
