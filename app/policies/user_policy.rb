class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.role_scope.eql? 'total'
        scope.where.not(id: @user.id)
      else
        scope.where(role_id: @user.role_id).where.not(id: @user.id)
      end
    end
  end
end
