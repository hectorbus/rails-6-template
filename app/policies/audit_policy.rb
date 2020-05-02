class AuditPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.role_scope.eql? 'total'
        scope.all
      elsif @user.role_scope.eql? 'owner'
        scope.where(user_id: @user.id)
      else
        scope.none
      end
    end
  end
end
