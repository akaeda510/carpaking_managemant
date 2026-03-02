class Admin::DashboardPolicy < AdminPolicy
  def index?
    super
  end

  class Scope < AdminPolicy::Scope
    def resolve
      super
    end
  end
end
