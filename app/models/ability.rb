class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if !user.id.nil?
      can :read, Post
      if user.username=="tester"
        puts 'yes'
        can :manage, Post
      end
    else

    end
    puts user.username

  end
end
