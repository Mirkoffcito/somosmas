module ErrorsHelper extend ActiveSupport::Concern
  included do
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def parameter_missing
      render json: {error: 'Parameter is missing or its value is empty'}, status: :bad_request
    end

    def not_found
      render json: {error: "#{controller_name.singularize} not found"}, status: :not_found
    end
  end
end