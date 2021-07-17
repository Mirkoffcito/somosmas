module Api
  class MessagesController < ApplicationController
    skip_before_action :authenticate_admin, only: :show

    def show
      render json: message, serializer: MessageSerializer, status: :ok
    end
    
    private

    def message
      @message ||= @current_user.messages.find(params[:id])
    end
    
    def chat 
      @chat ||= Chat.find(params[:id])
    end
    
  end
end