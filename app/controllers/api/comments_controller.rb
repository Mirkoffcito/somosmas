module Api
  class CommentsController < ApplicationController
    skip_before_action :authenticate_admin, only: [:create, :update, :destroy]

    def index
      @comments = Comment.all
      render json: @comments
    end

    def create
      @comment = Comment.new(comment_params)
      @comment.user_id = @current_user.id if @current_user
      if @comment.save
        byebug
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def update
      if comment.user_id == @current_user.id || @current_user.role.admin?
        comment.update(comment_params)
        render json: @comment, serializer: CommentSerializer, status: :ok
      else
        render json: { message: 'Unauthorized access.' }, status: :unauthorized
      end
    end

    def destroy
      if comment && comment.user_id == @current_user.id || @current_user.role.admin?
        comment.delete
        render json: { message: 'Succesfully deleted' }, status: :ok
      else 
        render json: { message: 'Unauthorized access.' }, status: :unauthorized
      end  
    end 

    private

    def comment
      @comment ||= Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:new_id, :content)
    end

  end
end
