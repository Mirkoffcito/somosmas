module ErrorsHelper extend ActiveSupport::Concern
  included do
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    
    def parameter_missing
      render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
    end
  end
end