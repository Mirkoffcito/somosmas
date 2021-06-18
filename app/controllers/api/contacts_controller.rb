module Api
  class ContactsController < ApplicationController
    skip_before_action :authenticate_admin

    def index
        @contacts = Contact.select { |contact| contact.user_id == @current_user.id }
      if @contacts != nil?
        render json: @contacts, status: :ok
      else 
        render json: @contacts.errors, status: :unprocessable_entity
      end
      @contacts = @current_user.contacts
      render json: @contacts, each_serializer: ContactSerializer
    end

    def create
    @contact = Contact.new(contact_params)
    @contact.user_id = @current_user.id if @current_user
      if @contact.save
        render json: @contact, status: :created
      else
        render json: @contact.errors, status: :bad_request
      end
    end
    
    private

    def contact_params
      params.require(:contact).permit(:name, :message, :email)
    end

  end
  
end
