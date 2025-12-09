class DashboardPolicy < ApplicationPolicy
  def show?
    @parking_manager.present?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(parking_manager_id: @parking_manager.id)
    end
  end
end
