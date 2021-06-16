module Api
    class ContactsController < ApplicationController
        before_action :authorize_request

        def index
                @contacts = Contact.select { |contact| contact.user_id == @current_user.id }
            if @contacts != nil?
                render json: @contacts
            else 
                render json: @contacts.errors, status: :unprocessable_entity
            end
        end
    end
end
