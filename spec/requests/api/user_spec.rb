# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { attributes_for :user }

  before(:all) do
    @admin_user = create(:user, :admin_user)
    @client_user = create(:user, :client_user)
  end

  describe 'GET /api/users' do
    context 'when users is logged' do
      subject { get '/api/users', headers: @headers }
      let!(:users) { create_list(:user, 8) }

      context 'when user is admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns a status OK' do
          subject
          expect(response).to have_http_status(:success)
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

        it 'returns a status unauthorized' do
          get '/api/users'
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user is client' do
        before do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns an error message' do
          subject
          expect(response.body).to include('You are not an administrator')
        end
      end
    end
  end

  describe 'PATCH api/users/:id' do
    subject { patch "/api/users/#{@id}", params: @params, headers: @headers }

    context 'when user is logged' do
      before(:each) do
        login_with_api(@admin_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end

      it 'changes the name correctly' do
        json_response[:user][:first_name] = 'Jose'
        @params = { user: { first_name: json_response[:user][:first_name] } }
        subject
        expect(json_response[:user][:first_name]).to eq('Jose')
        expect(response).to have_http_status(:ok)
      end

      it 'returns error and a status bad request with last name blank' do
        json_response[:user][:last_name] = ' '
        @params = { user: { last_name: json_response[:user][:last_name] } }
        subject
        expect(response.body).to include("can't be blank")
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error and a status bad request with invalid email' do
        json_response[:user][:email] = 'correo-no-valido'
        @params = { user: { email: json_response[:user][:email] } }
        subject
        expect(response.body).to include('is invalid')
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns a status unauthorized if not pass token' do
        json_response[:user][:first_name] = Faker::Name.first_name
        @params = { user: { first_name: json_response[:user][:first_name] } }
        patch "/api/users/#{@id}", params: @params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a status forbidden' do
        @client_user.first_name = 'Pedro'
        @params = { user: { first_name: @client_user.first_name } }
        patch "/api/users/#{@client_user.id}", params: @params, headers: @headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE api/users/:id' do
    context 'when user is logged' do
      before(:each) do
        login_with_api(@client_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end

      context 'with token' do
        it 'returns a status ok and success message' do
          delete "/api/users/#{@id}", headers: @headers
          expect(response.body).to include('Succesfully deleted')
          expect(response).to have_http_status(:ok)
        end

        it 'deletes a user' do
          expect do
            subject
          end.to change { User.count }.by(0)
        end

        it 'returns a status forbidden for other :id' do
          delete "/api/users/#{@admin_user.id}", headers: @headers
          expect(response.body).to include('You do not have permission')
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'without token' do
        it 'returns a status unauthorized and error message' do
          delete "/api/users/#{@id}"
          expect(response.body).to include('Unauthorized access.')
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
