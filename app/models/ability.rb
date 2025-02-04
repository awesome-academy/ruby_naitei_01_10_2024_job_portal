class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      admin_abilities
    elsif user.business?
      business_abilities(user)
    elsif user.user?
      user_abilities(user)
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def business_abilities user
    can :read, User, role: User.roles[:user]
    can :manage, Job, company_id: user.company_id
    can :manage, Application, job: {company_id: user.company_id}
    can :manage, InterviewProcess,
        application: {job: {company_id: user.company_id}}
    can :read, Company, id: user.company_id
    can :update, Company, id: user.company_id
  end

  def user_abilities user
    can :read, Job
    can :create, Application
    can :read, Application, user_id: user.id
    can :manage, UserProfile, user_id: user.id
    can :manage, UserSocialLink, user_id: user.id
    can :read, Company
    can :read, Notification
  end

  def guest_abilities
    can :read, Job
    can :read, Company
  end
end
