require 'rails_helper'

RSpec.describe "Authentications", type: :request do

    before(:all) do
        create(:admin)
    end

    describe "POST api/auth/register" do

        let (:registration) {register_with_api(attributes)}
        let (:attributes) { attributes_for :user }

        context 'when succesfully registers a new user' do

            before do |example|
                unless example.metadata[:skip_before]
                    registration
                end
            end

            it 'should change Users count by 1', skip_before: true do
                expect{registration}.to change(User, :count).by(1)
            end

            it 'should return a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'should return a TOKEN' do
                expect(json_response[:user]).to have_key(:token)
            end

            it 'should return the users info' do
                new_user = User.new(attributes)
                compare(json_response, new_user)
            end
        
        end

        context 'when it fails to register a new user' do

            before do |example|
                attributes[:password_confirmation] = nil
                unless example.metadata[:skip_before]
                    registration
                end
            end

            it 'should not change Users count' do
                expect{registration}.not_to change(User, :count)
            end

            it 'should return a HTPP STATUS 422' do
                expect(response).to have_http_status(:unprocessable_entity)
            end

        end

        context 'when it fails to register a new user because of incorrect password_confirmation' do

            before do
                attributes[:password_confirmation] = nil
                registration
            end

            it 'should return a HTPP STATUS 422' do
                expect(response).to have_http_status(:unprocessable_entity)
            end

        end

        context 'when it fails to register a new user because of an already registered email' do
            
            before do
                User.create! attributes
                registration
            end

            it 'should return a HTTP STATUS 422' do
                expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'should return a JSON detailing the error' do
                expect(json_response[:email]).to eq(["has already been taken"])
            end
        end

    describe "POST api/auth/login" do

        before do
            @user = User.create! attributes
        end
        
        context 'when it succesfully logins' do
            
            before do
                login_with_api(@user)
            end

            it 'should return a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'should return the users info' do
                compare(json_response, @user)
            end

            it 'should return a TOKEN' do
                expect(json_response[:user]).to have_key(:token)
            end

        end

        context 'when it fails to login' do
            before do
                @user[:email] = "guido1234gmail.com"
                login_with_api(@user) 
            end
            
            it 'should return a HTTP STATUS 400' do
                expect(response).to have_http_status(:bad_request)
            end

            it 'should return a message error' do
                expect(json_response[:error]).to eq("Invalid user or password")
            end
        end

    end

    describe "GET api/auth/me" do
        
        context 'when it succesfully renders the current user info' do

            before do
                @user = User.create! attributes
                login_with_api(@user)
                get api_auth_me_url, headers: {Authorization: json_response[:user][:token]}
            end

            it 'returns a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'returns the current user info' do
                compare(json_response, @user)
            end

        end

        context 'when it fails to render current user info because of bad token' do

            before do
                get api_auth_me_url, headers: {Authorization: "123456789"}
            end
        
            it 'should return a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'should return a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end

        end

    end

    end
end
