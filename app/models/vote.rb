class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  validates_uniqueness_of :user_id, :scope => [:voteable_id, :voteable_type]
  validates_presence_of :voteable_type, :voteable_id, :vote, :user_id

  scope :up, lambda{  Vote.where('vote=?','up') }
  scope :down, lambda{  Vote.where('vote=?','down') }
end
