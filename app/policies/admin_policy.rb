class AdminPolicy < ApplicationPolicy
  attr_reader :admin, :record

  def initialize(admin, record)
    @admin = admin
    @record = record
  end

  def new?
    create?
  end

  def create?
    admin.is_a?(Admin)
  end

  def show?
    admin.is_a?(Admin)
  end

  def index?
    admin.is_a?(Admin)
  end

  def edit?
    update?
  end

  def update?
    admin.is_a?(Admin)
  end

  def destroy?
    admin.is_a?(Admin)
  end

  class Scope < ApplicationPolicy::Scope
    def initialize(admin, scope)
      @admin = admin
      @scope = scope
    end

    def resolve
      if admin.is_a?(Admin)
        scope.all
      else
        scope.none
      end
    end
  end
end
