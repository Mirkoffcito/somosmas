module AuthorizeApiRequest

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    @decoded = JsonWebToken.decode(header)
    @current_user = User.find(@decoded[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: { message: 'Unauthorized access.' }, status: :unauthorized
  end

  def user_authorize
    if !@current_user.role.admin?
      render json: { error: 'Unauthorized access.' }, status: :unauthorized
    end
  end
end