# frozen_string_literal: true

module Api
  class ChatsController < ApplicationController


    def index
        @chats = @current_user.chats
        paginate @chats, per_page: 10, each_serializer: ChatSerializer
    end

  end
end
