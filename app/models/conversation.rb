class Conversation < ActiveRecord::Base
  #before_destroy :delete_all_message_notifications
  #after_create :notify_item_owner, :if => Proc.new{ self.item != nil }


  belongs_to :user
  #belongs_to :item
  has_many :messages, :class_name => "Message", :dependent => :delete_all
  #has_many :notifications, :as => :notifier, :dependent => :delete_all
  #has_many :message_notifications, :through => :messages, :source => :notifications

  #validates :user_id, :exclusion => { :in => lambda { |conversation|
    #[Item.find(conversation.item_id).user_id]
  #}, :message => "You cannot message yourself about your own item." }, :unless => "item.nil?"

  #validate :item_type_is_allowed
  scope :from_user, lambda { |user| where(user_id: user.id) }
  scope :for_user, lambda { |user| where(recipient_id: user.id) }
  #scope :for_user_message, lambda{ |user| {:joins => :notifications, :conditions => ["receiver_id = ? and offers.item_id is null", user.id]}}

  def unread_message_count(usr)
    unread_message_count ||= Message.where("conversation_id = ? and user_id != ?", self.id, usr.id).count
  end
=begin
  private

  def delete_all_message_notifications
    Notification.delete_all(:id => self.message_notifications.collect(&:id))
  end

  def item_type_is_allowed
    #errors.add(:item, "type not allowed") unless item.allows_offers?
    true
  end

  def notify_item_owner
    notification = Notification.new
    notification.notifier = self
    notification.sender = self.user
    notification.receiver = self.item.user
    notification.save
  end

  def self.count_by_day(cutoff_at)
    result = count(:all, :conditions => ["created_at >= ?", cutoff_at],
                         :group => "DATE(created_at)")
    # See http://ruby-doc.org/core-1.8.7/classes/Hash.html#M000163
    result.default = 0
    result
  end
=end
end
