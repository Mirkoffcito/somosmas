module Api
  class ContactsController < ApplicationController
    skip_before_action :authenticate_admin

    def index
      if @current_user.role.admin?
        @contacts = Contact.all
        render json: @contacts, each_serializer: ContactSerializer
      else
        render json: { message: 'Unauthorized access.' }, status: :unauthorized
      end
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

    def show
      @contacts = @current_user.contacts
      render json: @contacts, each_serializer: ContactSerializer
    end
    
    private

    def contact_params
      params.require(:contact).permit(:name, :message, :email)
    end

  end
  
end
