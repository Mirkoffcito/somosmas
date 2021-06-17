module Api
  class CommentsController < ApplicationController
    def index
      @comments = Comment.all
      render json: @comments
    end

    def create
      @comment = Comment.new(comment_params)
      @comment.user_id = @current_user.id if @current_user
      if @comment.save
        render json: @comment, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:new_id, :content)
    end

  end
end
