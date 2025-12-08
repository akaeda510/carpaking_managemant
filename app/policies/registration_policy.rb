class RegistrationPolicy < ApplicationPolicy

  def edit?
    @parking_manager.id == @record.parking_manager_id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(parking_manager.id: @parking_manager.id)
    end
  end
end
