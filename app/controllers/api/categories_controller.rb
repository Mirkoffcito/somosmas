class Api::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :user_authorize

  def index
    @categories = Category.all()
    render json: @categories, each_serializer: CategorySerializer
  end

end
