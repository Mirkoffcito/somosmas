# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations', type: :request do

  let (:admin) { attributes_for :admin_user }
  let (:client) { attributes_for :client_user }
  before { create(:organization) }
  
  describe '.index' do
    context 'when Organization exist' do
      it 'returns an HTTP STATUS 200' do
        get '/api/organization/public'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '.update' do
    context 'when user is admin' do
      before do
        create(:admin_role)
        create(:admin_user)
        register_with_api(admin)
      end

      context 'with valids parameters' do
        before do
          token = json_response[:user][:token]
          @json_response = nil
          organization_update = 
            { "organization": {
            "name":"Somos Mas",
            "address":"1234124" } }
          
          patch '/api/organization/public', headers: {'Authorization': token}, params: organization_update
        end
        it 'returns an HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid parameters' do
        before do
          token = json_response[:user][:token]
          @json_response = nil
          patch '/api/organization/public', headers: {'Authorization': token}
        end
        it 'returns an HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end
        it 'returns a message error' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end
    end

    context 'when user not admin' do
      before do
        create(:client_role)
        create(:client_user)
      end

      context 'with client user' do
        before do
          register_with_api(client)
          token = json_response[:user][:token]
          @json_response = nil
          patch '/api/organization/public', headers: {'Authorization': token}
        end
        it 'returns an HTTP STATUS 401' do
          expect(response).to have_http_status(:unauthorized)
        end
        it 'returns a message error' do
          expect(json_response[:error]).to eq("You are not an administrator") 
        end
      end

      context 'with public user' do
        before do
          patch '/api/organization/public'
        end
        it 'returns an HTTP STATUS 401' do
          expect(response).to have_http_status(:unauthorized)
        end
        it 'returns a message error' do
          expect(json_response[:message]).to eq("Unauthorized access.")
        end
      end
    end
  end
end