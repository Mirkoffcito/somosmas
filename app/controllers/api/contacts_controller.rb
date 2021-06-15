module Api
class ContactsController < ApplicationController
    before_action ::authorize_request

    def show
            @contacts = Contact.all.select{ |contact| contact.user_id == @current_user.id }
        if @contacts != nil?
            render json: @contacts.all
        else 
            render json: @contacts.errors, status: :unprocessable_entity

    end

end
