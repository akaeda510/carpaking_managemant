class Admin::ParkingManagerPolicy < AdminPolicy
  def show?
    super
  end

  def index?
    super
  end

  class Scope < AdminPolicy::Scope
    def resolve
      super
    end
  end
end
