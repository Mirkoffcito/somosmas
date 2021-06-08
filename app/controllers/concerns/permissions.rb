module Permissions extend ActiveSupport::Concern

  def authenticate_admin
    render json: { error: 'You are not an administrator' }, status: :unauthorized unless @current_user.role.admin?
  end

end