# frozen_string_literal: true

module Permissions
  extend ActiveSupport::Concern
  def authenticate_admin
    unless @current_user.role.admin?
      render json: { error: 'You are not an administrator' },
             status: :unauthorized
    end
  end
end
