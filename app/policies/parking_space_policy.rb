class ParkingSpacePolicy < ApplicationPolicy
  def create?
    @parking_manager.present? && parking_manager.id == record.pa    rking_manager_id
  end

  def show?
    create?
  end

  def index?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(parking_manager_id: parking_manager.id)
    end
  end
end
