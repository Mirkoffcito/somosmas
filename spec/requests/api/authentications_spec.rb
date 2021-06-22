require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  let (:valid_attributes) { attributes_for :user }
  let (:invalid_attributes) { attributes_for :invalid_user }


  describe "POST api/auth/register" do

    context 'with valid parameters' do
      
      it 'succesfuly registers a new user and returns a token' do
        expect do
          post api_auth_register_url,
            params: { user: valid_attributes}, as: :json
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(json_response[:user]).to have_key(:token)
      end
    end

    context 'with invalid parameters' do
      it 'renders JSON Response with a unprocessable entity status' do
        expect do
          post api_auth_register_url,
            params: {user: invalid_attributes}, as: :json
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with an email already registered account' do
      before do
      it 'renders a status error 422 with details about the error' do
        
      end
    end

    context 'with a password too short (less than 8 characters)' do
      it 'renders a status error 422 with details about the error' do
        
      end
    end

    context 'with different password and password_confirmation fields' do
      it 'renders a status error 422 with details about the error' do
        
      end
    end
  end
end
