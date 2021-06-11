class Api::NewsController < ApplicationController
  before_action :authenticate_admin, only: %i[create destroy show update]
  before_action :new, only: %i[show destroy update]

  def show
    render json: @new, status: :ok
  end

  def create
    @new = New.new(new_params)
    if @new.save
      render json: @new, status: :created
    else
      render json: @new.errors, status: :bad_request
    end
  end

  def update
    if @new.update(new_params)
      render json: @new, status: :ok
    else
      render json: @new.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { message: 'Successfully deleted' }, status: :ok if @new.destroy
  end

  def new
    @new = New.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'New not found' }, status: :not_found
  end

  private

  def new_params
    params.require(:new).permit(:name, :content, :category_id)
  end
end
