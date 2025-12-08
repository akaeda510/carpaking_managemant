class DashboardPolicy < ApplicationPolicy

  def show?
    @parking_manager.id == @recoed.parking_manager_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(parking_manager.id = @parking_manager.id)
    end
  end
end
