# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { attributes_for :user }

  before(:all) do
    @admin_user = create(:user, :admin_user)
    @client_user = create(:user, :client_user)
  end

  describe 'GET /api/users' do
    context 'when users is not logged' do
      it 'returns a status unauthorized' do
        get '/api/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when users is logged' do
      subject { get '/api/users', headers: @headers }
      # User.skip_callback(:create, :after, :send_mail)
      let!(:users) { create_list(:user, 8) }

      context 'when user is admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns a status OK' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns an array' do
          expect(response).to respond_to(:to_a)
        end

        it 'returns a list of users' do
          expect(users).to all(be_instance_of User)
        end

        it 'returns a list of all users' do
          expect(users.length).to eq(8)
        end
      end

      context 'when user is client' do
        before do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          @json_response = nil
          subject
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an array' do
          expect(response).to respond_to(:to_a)
        end

        it 'returns a list of users' do
          expect(users).to all(be_instance_of User)
        end

        it 'returns a list of all users' do
          expect(users.length).to eq(8)
        end

        it 'returns only id, first name and last name of each user' do
          json_response[:users].each do |user|
            expect(user).to have_key(:id)
            expect(user).to have_key(:first_name)
            expect(user).to have_key(:last_name)
            expect(user).not_to have_key(:email)
          end
        end
      end
    end
  end

  describe 'GET api/users/:id' do
    subject(:get_user) { get "/api/users/#{@id}", headers: { Authorization: token } }
    
    context 'when the token is valid' do
      let(:token) { json_response[:user][:token] }

      context 'when user does not exist' do
        before do
          login_with_api(@client_user)
          @id = 144
          token
          @json_response = nil
          get_user
        end

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an user not found message' do
          expect(json_response[:error]).to eq('user not found')
        end
      end
      
      context "when user is admin" do
        before do
          login_with_api(@admin_user)
          @id = @admin_user.id
          token
          @json_response = nil
          get_user
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'checks user to have id, first_name, last_name, email and role keys' do
          json_response[:user] do |user|
            expect(user).to have_key(:id)
            expect(user).to have_key(:first_name)
            expect(user).to have_key(:last_name)
            expect(user).to have_key(:email)
            expect(user).to have_key(:role)
          end
        end

      end

      context "when user is client" do
        before do
          login_with_api(@client_user)
          @id = @client_user.id
          token
          get_user
          @json_response = nil
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'checks user to have id, first_name, last_name, email' do
          json_response[:user] do |user|
            expect(user).to have_key(:id)
            expect(user).to have_key(:first_name)
            expect(user).to have_key(:last_name)
            expect(user).to have_key(:email)
          end
        end

        it 'checks user not to have role, password keys' do
          expect(json_response[:user]).not_to have_key(:role)
          expect(json_response[:user]).not_to have_key(:password)
        end
      end

    end

    context 'when the token is invalid' do
      let(:token) { 'random_token' }
      before { get_user }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
  end

  describe 'PATCH api/users/:id' do
    context 'when users is not logged' do
      it 'returns a status unauthorized' do
        @id = 1
        @params = { user: { first_name: 'Otro nombre' } }
        patch "/api/users/#{@id}", params: @params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged' do
      context 'when user is client' do
        subject { patch "/api/users/#{@id}", params: @params, headers: @headers }

        before(:each) do
          login_with_api(@client_user)
          @id = json_response[:user][:id]
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        context 'when correct params' do
          it 'changes the name correctly' do
            json_response[:user][:first_name] = 'Luis'
            @params = { user: { first_name: json_response[:user][:first_name] } }
            subject
            expect(json_response[:user][:first_name]).to eq('Luis')
          end

          it 'returns a status ok' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when invalid or missing params' do
          it 'returns error with last name blank' do
            json_response[:user][:last_name] = ' '
            @params = { user: { last_name: json_response[:user][:last_name] } }
            subject
            expect(response.body).to include("can't be blank")
          end

          it 'returns error with invalid email' do
            json_response[:user][:email] = 'correo-no-valido'
            @params = { user: { email: json_response[:user][:email] } }
            subject
            expect(response.body).to include('is invalid')
          end

          it 'returns a status bad request without params' do
            patch "/api/users/#{@id}", headers: @headers
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns a status forbidden' do
            @client_user.first_name = 'Pedro'
            @params = { user: { first_name: @client_user.first_name } }
            patch "/api/users/#{@admin_user.id}", params: @params, headers: @headers
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'when user is admin' do
        subject { patch "/api/users/#{@id}", params: @params, headers: @headers }

        before(:each) do
          login_with_api(@admin_user)
          @id = json_response[:user][:id]
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        context 'when correct params' do
          it 'changes the name correctly' do
            json_response[:user][:first_name] = 'Jose'
            @params = { user: { first_name: json_response[:user][:first_name] } }
            subject
            expect(json_response[:user][:first_name]).to eq('Jose')
          end

          it 'returns a status ok' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when invalid or missing params' do
          it 'returns error with last name blank' do
            json_response[:user][:last_name] = ' '
            @params = { user: { last_name: json_response[:user][:last_name] } }
            subject
            expect(response.body).to include("can't be blank")
          end

          it 'returns error with invalid email' do
            json_response[:user][:email] = 'correo-no-valido'
            @params = { user: { email: json_response[:user][:email] } }
            subject
            expect(response.body).to include('is invalid')
          end

          it 'returns a status bad request without params' do
            patch "/api/users/#{@id}", headers: @headers
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns a status forbidden' do
            @client_user.first_name = 'Pedro'
            @params = { user: { first_name: @client_user.first_name } }
            patch "/api/users/#{@client_user.id}", params: @params, headers: @headers
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe 'DELETE api/users/:id' do
    context 'when users is not logged' do
      it 'returns a status unauthorized' do
        @id = 1
        @params = { user: { first_name: 'Otro nombre' } }
        patch "/api/users/#{@id}", params: @params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged' do
      context 'when user is client' do
        subject { delete "/api/users/#{@id}", headers: @headers }

        before(:each) do
          login_with_api(@client_user)
          @id = json_response[:user][:id]
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        context 'when correct params' do
          it 'returns a status ok' do
            subject
            expect(response).to have_http_status(:ok)
          end

          it 'deletes a user' do
            expect do
              subject
            end.to change { User.count }.by(-1)
          end
        end

        context 'when invalid or missing params' do
          it 'returns a status forbidden for other :id' do
            delete "/api/users/#{@admin_user.id}", headers: @headers
            expect(response.body).to include('You do not have permission')
            expect(response).to have_http_status(:forbidden)
          end

          it 'returns a status unauthorized' do
            delete "/api/users/#{@id}"
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'when user is admin' do
        subject { delete "/api/users/#{@id}", headers: @headers }

        before(:each) do
          login_with_api(@admin_user)
          @id = json_response[:user][:id]
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        context 'when correct params' do
          it 'deletes a user' do
            expect do
              subject
            end.to change { User.count }.by(-1)
          end

          it 'returns a status ok' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when invalid or missing params' do
          it 'returns a status forbidden for other :id' do
            delete "/api/users/#{@client_user.id}", headers: @headers
            expect(response.body).to include('You do not have permission')
            expect(response).to have_http_status(:forbidden)
          end

          it 'returns a status unauthorized' do
            delete "/api/users/#{@id}"
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
