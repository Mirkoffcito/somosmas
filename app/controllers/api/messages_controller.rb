# frozen_string_literal: true

module Api
  class MessagesController < ApplicationController
    skip_before_action :authenticate_admin, only: %i[show create index update]

    def index
      if chat.users.to_a.any?(@current_user)
        paginate @chat.messages.includes(:user), per_page: 10, each_serializer: MessageSerializer
      end
    end

    def show
      render json: message, serializer: MessageSerializer, status: :ok
    end

    def create
      @message = chat.messages.new(message_params)
      @message.user_id = @current_user.id
      if @message.save
        render json: @message, serializer: MessageSerializer, status: :created
      else
        render json: @message.errors, status: :bad_request
      end
    end

    def update
      last_message = chat.messages.last
      @message = Message.find(params[:message_id])

      if last_message.id != message.id
        return render json: { message: 'This is not the last message of this chat' },
                      status: :unauthorized
      end
      if message.user_id != @current_user.id
        return render json: { message: 'You are not the owner of this message' },
                      status: :unauthorized
      end

      @message.update(message_update_params.merge({ modified: true }))
      render json: @message, serializer: MessageSerializer, status: :ok
    end

    private

    def message
      @message ||= @current_user.messages.find(params[:id])
    end

    def chat
      @chat ||= Chat.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:detail)
    end

    def message_update_params
      params.require(:message).permit(:detail)
    end
  end
end
