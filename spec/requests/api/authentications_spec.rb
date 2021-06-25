require 'rails_helper'

# The custom methods(compare_user, register_with_api, )
# used in this file can be found in
# spec/support/auth_helpers.rb

RSpec.describe "Authentications", type: :request do
    
    let (:attributes) { attributes_for(:user, :admin_user) }
    describe "POST api/auth/register" do

        subject(:registration) {
            post api_auth_register_url, params: { user: attributes, as: :json } 
        }

        context 'when succesfully registers a new user' do

            before do |example|
                registration unless example.metadata[:skip_before]
            end

            it 'changes Users count by 1', skip_before: true do
                expect{registration}.to change(User, :count).by(1)
            end

            it 'returns a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'returns a TOKEN' do
                expect(json_response[:user]).to have_key(:token)
            end

            it 'returns the users info' do
                new_user = User.new(attributes)
                compare_user(json_response, new_user)
            end
        
        end

        context 'when email param is incorrect' do

            before do |example|
                attributes[:email] = 'guido10mdgmail.com'
                registration unless example.metadata[:skip_before]
            end

            it 'does not change Users count' do
                expect{registration}.not_to change(User, :count)
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
                expect(json_response[:email]).to eq(["has already been taken"])
            end
        end
    end

    describe "POST api/auth/login" do
        before {@user = create(:user, attributes)}

        context 'when credentials are correct' do
            
            before {login_with_api(@user)}

            it 'returns a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'returns the users info' do
                compare_user(json_response, @user)
            end

            it 'returns a TOKEN' do
                expect(json_response[:user]).to have_key(:token)
            end

        end

        context 'when credentials are incorrect' do
            before do
                @user[:email] = "guido1234gmail.com"
                login_with_api(@user) 
            end
            
            it 'returns a HTTP STATUS 400' do
                expect(response).to have_http_status(:bad_request)
            end

            it 'returns a message error' do
                expect(json_response[:error]).to eq("Invalid user or password")
            end
        end
    end

    describe "GET api/auth/me" do
        
        subject(:get_me) {get api_auth_me_url, headers: {Authorization: token}}

        context "when the token is valid" do
            before do
                @user = create(:user, attributes)
                login_with_api(@user)
                get_me
            end
            let(:token) { json_response[:user][:token] }
            it 'returns a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'returns the current user info' do
                compare_user(json_response, @user)
            end

        end

        context "when the token is invalid" do
            before { get_me }
            let(:token) { "1231251231231" }
        
            it 'returns a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end
    end
end
