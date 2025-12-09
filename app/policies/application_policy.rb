# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :parking_manager, :record

  def initialize(parking_manager, record)
    @parking_manager = parking_manager
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(parking_manager, scope)
      @parking_manager = parking_manager
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :parking_manager, :scope
  end
end
