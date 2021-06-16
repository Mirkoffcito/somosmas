module Api
  class ContactsController < ApplicationController

    def create
      @contact = Contact.new(contact_params)
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