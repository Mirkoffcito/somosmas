class ChatsController < ApplicationController


    def index
        @chats = @current_user.chats
        paginate @chats, per_page: 10, each_serializer: ChatsSerializer
      end

end
