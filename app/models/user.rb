class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable
  attr_accessor :login
  validates :username,
  :uniqueness => {
    :case_sensitive => false
  }
  #validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/

  has_many :posts
  has_many :workspaces, :dependent => :delete_all
  has_many :subscriptions, :dependent => :delete_all
  has_many :comments
  has_many :reactions
  has_many :flag_votes
  has_many :awards, :dependent => :delete_all
  has_many :notifications, :foreign_key => :receiver_id, :dependent => :delete_all
  has_many :familiarities, :dependent => :delete_all
  #has_many :familiar_users, :dependent => :delete_all, :through => :familiarities, :source => :familiar,
    #:conditions => "#{Familiarity.table_name}.familiarness > 0",
    #:order => "#{Familiarity.table_name}.familiarness DESC"
  has_many :posts
  has_attached_file :avatar, :styles => { :medium => "200x200>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          username: auth.extra.raw_info.name.gsub(' ',''),
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def username_set?
    return true unless self.username.nil?
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def subscribed_users
    ids = Subscription.where(:subscription_id=>self.id,:subscription_type=>'user').pluck(:user_id)
    return User.find(ids)
  end

end
