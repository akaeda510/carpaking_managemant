class ParkingManagerPolicy < ApplicationPolicy

  def create?
    true
  end

  def show?
    @parking_manager.id == @record.id
  end

  def index?
    show?
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(id: @parking_manager.id)
    end
  end
end
