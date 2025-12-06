class ContractorPolicy < ApplicationPolicy

  def create?
    @parking_manager.present?
  end

  def show?
    @parking_manager.id == @record.parking_manager_id
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
      scope.where(parking_manager.id: @parking_manager.id)
    end
  end
end
