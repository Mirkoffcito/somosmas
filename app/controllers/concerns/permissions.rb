module Permissions extend ActiveSupport::Concern

  def authenticate_admin
    render json: { error: 'You are not an administrator' }, status: :unauthorized unless @current_user.is_admin?
  end

end