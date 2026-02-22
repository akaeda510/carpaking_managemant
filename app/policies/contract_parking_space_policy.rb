class ContractParkingSpacePolicy < ApplicationPolicy
  def create?
    @parking_manager.present? && parking_manager.id == record.parking_manager_id
  end

  def new?
    create?
  end

  class Scope < ApplicationPolicy::Scope
    def resolva
      scope.where(parking_manager_id: parking_manager.id)
    end
  end
end
