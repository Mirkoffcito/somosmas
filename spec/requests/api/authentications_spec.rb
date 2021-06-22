require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  let (:valid_attributes) { attributes_for :user }
  let (:invalid_email) { attributes_for :user_without_email }
  let (:invalid_password) { attributes_for :user_without_password_confirmation}


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
      it 'returns an unprocessable entity status when no email is provided' do
        expect do
          post api_auth_register_url,
            params: {user: invalid_email}, as: :json
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an unprocessable entity status when no password_confirmation is provided' do
        expect do
          post api_auth_register_url,
            params: {user: invalid_password}, as: :json
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end

    context 'with an already registered email' do
      let (:existing_user) { attributes_for :user }

      it 'returns an unprocessable entity status when the email is taken already' do
        registered_user = User.create! valid_attributes
        existing_user[:email] = registered_user[:email]
        post api_auth_register_url, params: {user: existing_user}, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  describe "POST api/auth/login" do
    
    context 'succesfully login' do
      it 'returns an OK(200) http status and a token' do
        new_user = User.create! valid_attributes
        login_with_api(new_user)
        expect(response).to have_http_status(:ok)
        expect(json_response[:user]).to have_key(:token)
      end
    end

    context 'failed to login' do
      it 'returns a bad request(400) http status and renders an error if the credentials are invalid' do
        new_user = User.new valid_attributes
        post api_auth_login_url, params: {user: {email: new_user.email, password: new_user.password}}
        expect(response).to have_http_status(:bad_request)
        expect(json_response[:error]).to eq("Invalid user or password")
      end
    end

  end

  describe "GET api/auth/me" do
  
    context 'succesfully renders the current user info' do

      it 'returns an OK(200) http status and renders the current user info' do
        new_user = User.create! valid_attributes
        login_with_api(new_user)
        get api_auth_me_url, headers: {Authorization: json_response[:user][:token]}
        expect(response).to have_http_status(:ok)
        expect(json_response[:user][:email]).to eq(new_user.email)
      end
    end
      
    context "fails to get user's info because of bad token" do

      it 'returns an 401(unauthorized) http status and renders an error' do
        get api_auth_me_url, headers: {Authorization: "123456789"}
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:message]).to eq("Unauthorized access.")
      end

    end
  
  end

end
