require 'rails_helper'

RSpec.describe 'Authentications', type: :request do

  shared_examples "compares user from returned JSON with current user" do |subject|
    let(:token) { json_response[:user][:token] } # gets the token
    let(:decoded) { JsonWebToken.decode(token) } # decodes it
    let(:current_user) { User.find(decoded[:user_id]) } # findes the user from the token

    it "returns the #{subject} user info" do
      expect(json_response[:user][:id]).to eq(current_user.id)
      expect(json_response[:user][:email]).to eq(current_user.email)
      expect(json_response[:user][:first_name]).to eq(current_user.first_name)
      expect(json_response[:user][:last_name]).to eq(current_user.last_name)
    end
  end

  let(:attributes) { attributes_for(:user, :admin_user) }
  describe 'POST api/auth/register' do
    subject(:registration) do
      post api_auth_register_url, params: { user: attributes, as: :json }
    end

    context 'when succesfully registers a new user' do
      before do |example|
        registration unless example.metadata[:skip_before]
      end

      it 'changes Users count by 1', skip_before: true do
        expect { registration }.to change(User, :count).by(1)
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a TOKEN' do
        expect(json_response[:user]).to have_key(:token)
      end

      include_examples "compares user from returned JSON with current user", 'created'
    end

    context 'when email param is incorrect' do
      before do |example|
        attributes[:email] = 'guido10mdgmail.com'
        registration unless example.metadata[:skip_before]
      end

      it 'does not change Users count' do
        expect { registration }.not_to change(User, :count)
      end

      it 'returns a HTPP STATUS 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when password_confirmation param is incorrect' do
      before do
        attributes[:password_confirmation] = nil
        registration
      end

      it 'returns a HTPP STATUS 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when email sent as param is already registered' do
      before do
        create(:user, attributes)
        registration
      end

      it 'returns a HTTP STATUS 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a JSON detailing the error' do
        expect(json_response[:email]).to eq(['has already been taken'])
      end
    end
  end

  describe 'POST api/auth/login' do
    let(:user) { create(:user, attributes) }

    context 'when credentials are correct' do
      before { login_with_api(user) }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a TOKEN' do
        expect(json_response[:user]).to have_key(:token)
      end

      include_examples "compares user from returned JSON with current user", 'logged'
    end

    context 'when credentials are incorrect' do
      before do
        user[:email] = 'guido1234gmail.com'
        login_with_api(user)
      end

      it 'returns a HTTP STATUS 400' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns a message error' do
        expect(json_response[:error]).to eq('Invalid user or password')
      end
    end
  end

  describe 'GET api/auth/me' do
    subject(:get_me) { get api_auth_me_url, headers: { Authorization: token } }

    context 'when the token is valid' do
      let(:token) { json_response[:user][:token] }
      let(:user) { create(:user, attributes) }
      before do
        login_with_api(user)
        get_me
      end
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      include_examples "compares user from returned JSON with current user", 'current'
    end

    context 'when the token is invalid' do
      let(:token) { '1231251231231' }
      before { get_me }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
  end
end
