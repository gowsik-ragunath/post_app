class Ability
  include CanCan::Ability
  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :update , Post do |post|
        post.user == user
      end
      can :destroy , Post do |post|
        post.user == user
      end
      can :update , Comment do |comment|
        comment.user == user
      end
      can :destroy , Comment do |comment|
        comment.user == user
      end
      can :manage, Topic
      can [:create ,:status, :filter,:rate] , Post
      can [:create , :rate] , Comment
      can :read, :all
    end
  end
end
