class ParkingManagerPolicy < ApplicationPolicy
  def show?
    @parking_manager.id == @record.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(id: @parking_manager.id)
    end
  end
end
