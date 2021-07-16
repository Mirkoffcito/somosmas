class ChatsController < ApplicationController


    def index
        @contacts = @current_user.chats
        paginate @testimonials, per_page: 10, each_serializer: TestimonialSerializer
      end

end
