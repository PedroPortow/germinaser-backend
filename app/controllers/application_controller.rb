class ApplicationController < ActionController::API
  def current_user_admin_or_owner
    current_user.admin? || current_user.owner?
  end
end
