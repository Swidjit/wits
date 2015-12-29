class Familiarity < ActiveRecord::Base

  belongs_to :user
  belongs_to :familiar, :class_name => 'User'

  validates_presence_of :user_id, :familiar_id, :familiarness

  validates_uniqueness_of :familiar_id, :scope => :user_id

  def self.update_all_users
    all_combos = User.select("#{User.table_name}.id AS user_id, familiar.id AS familiar_id").joins(
      "CROSS JOIN #{User.table_name} familiar").where("#{User.table_name}.id <> familiar.id")
    all_combos.each do |cmb|
      self.update_for(User.find(cmb.user_id), User.find(cmb.familiar_id))
    end
  end

  def self.update_for(user, familiar)
    return if user.id == familiar.id
    user_familiarity = Familiarity.find_or_initialize_by_user_id_and_familiar_id(user.id,familiar.id)
    new_familiarness = 0

=begin
    # +2 User comments on item posted by Familiar
    num_user_comments = user.comments.joins(:item).where("#{Item.table_name}.user_id = ?", familiar.id).count
    new_familiarness += (num_user_comments * 2)

    # +1 Familiar comments on item posted by User
    num_familiar_comments = familiar.comments.joins(:item).where("#{Item.table_name}.user_id = ?", user.id).count
    new_familiarness += (num_familiar_comments * 1)
=end    
    # +5 User sends message to Familiar


    if new_familiarness != 0 || user_familiarity.persisted?
      user_familiarity.familiarness = new_familiarness
      user_familiarity.save
    end
  end

end
