class ParkingManagerPolicy < ApplicationPolicy
  def index?
    parking_manager.present?
  end

  def show?
    @parking_manager.id == @record.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(id: @parking_manager.id)
    end
  end
end
