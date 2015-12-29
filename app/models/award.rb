class Award < ActiveRecord::Base

  belongs_to :post
  belongs_to :user


  scope :winner,  lambda{  Award.where(:award_type => 'winner') }
  scope :top10, lambda{   Award.where(:award_type => 'top10') }
  scope :top10pct, lambda{   Award.where(:award_type => 'top10pct') }

  after_create :notify_appropriate_user

  def notify_appropriate_user
      Notification.where(:notifier_type => "Award",:notifier_id => self.id, :receiver_id => self.user.id).delete_all
      notification = Notification.new
      notification.notifier = self
      #a hack to send from admin
      notification.sender = User.where(:username=>'admin').first
      notification.notifier_action = self.award_type
      notification.receiver = self.user

      notification.save
  end


end
