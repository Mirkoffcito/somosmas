module Api
  class MessagesController < ApplicationController
    skip_before_action :authenticate_admin, only: :show

    def show
      if message.user_id = @current_user.id
        render json: @message, each_serializer: MessageSerializer, status: :ok
      else
        render json: @message, status: :not_found
      end
    end
    
    private

    def message
      @message ||= Message.find(params[:id])
    end
    
    def chat 
      @chat ||= Chat.find(params[:id])
    end
    
  end
end