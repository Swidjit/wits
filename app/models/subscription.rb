class Subscription < ActiveRecord::Base

  belongs_to :user
  #has_many :email_digests, :dependent => :destroy

  validates_uniqueness_of :subscription_id, :scope => [:user_id, :subscription_type]



  validate :valid_subscription



  #after_save :update_importance
  #scope :in_country, lambda {|country| joins(:locations).where('locations.country = ?',country)}

  scope :users, lambda { |user| {
    :conditions => { :user_id => user.id, :subscription_type => 'user' }
  } }

  private
  def self.count_by_day(cutoff_at)
    result = count(:all, :conditions => ["created_at >= ?", cutoff_at],
                         :group => "DATE(created_at)")
    # See http://ruby-doc.org/core-1.8.7/classes/Hash.html#M000163
    result.default = 0
    result
  end

  def valid_subscription
    errors.add(:subscription_id, "you can't follow yourself") if subscription_id == user_id
  end
end
