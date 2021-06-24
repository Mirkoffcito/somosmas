# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations', type: :request do

  let (:admin_user) { attributes_for :admin_user }
  let (:client_user) { attributes_for :client_user }

  describe 'PATCH /api/organization/public' do

    before { FactoryBot.create(:organization) }

    context 'when user is admin, with empty parameters' do
      before do
        create(:admin_role)
        create(:admin_user)
        register_with_api(admin_user)
        token = json_response[:user][:token]
        @json_response = nil
        patch '/api/organization/public', headers: {'Authorization': token}
      end
      it 'should return an HTTP STATUS 400' do
        expect(response).to have_http_status(:bad_request)
      end
      it 'should return a message error' do
        expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
      end
    end

    context 'when user is admin, with parameters' do
      before do
        create(:admin_role)
        create(:admin_user)
        register_with_api(admin_user)
        # VER SI PUEDO METER FAKER PARA LOS DATOS DEL PUT

        organization_params =
          { "organization": {
          "name":"Somos Mas",
          "address":"1234124" } }
          
        token = json_response[:user][:token]
        @json_response = nil
        patch '/api/organization/public', headers: {'Authorization': token}, params: organization_params
        puts response.body
      end
      it 'should return an HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is client' do
      before do
        create(:client_role)
        create(:client_user)
        register_with_api(client_user)
        token = json_response[:user][:token]
        @json_response = nil
        patch '/api/organization/public', headers: {'Authorization': token}
      end
      it 'should return an HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'should return a message error' do
        expect(json_response[:error]).to eq("You are not an administrator")
      end
    end

    context 'when user is public' do
      before do
        patch '/api/organization/public'
      end
      it 'should return an HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'should return a message error' do
        expect(json_response[:message]).to eq("Unauthorized access.")
      end
    end

  end
end

#   describe 'GET /api/organization/public' do

#     before (:all) do
#       FactoryBot.create(:organization)
#     end

#     context 'when user is admin' do
#       before do
#         FactoryBot.create(:admin_role)
#         FactoryBot.create(:admin_user)
#         register_with_api(admin_user)
#         login_with_api(admin_user)
#         get '/api/organization/public', headers: {'Authorization': json_response[:user][:token]}
#       end
#       it 'should return an HTTP STATUS 200' do
#         expect(response).to have_http_status(:ok)
#       end
#     end

#     context 'when user is client' do
#       before do
#         FactoryBot.create(:client_role)
#         FactoryBot.create(:client_user)
#         register_with_api(client_user)
#         login_with_api(client_user)
#         get '/api/organization/public', headers: {'Authorization': json_response[:user][:token]}
#       end
#       it 'should return an HTTP STATUS 200' do
#         expect(response).to have_http_status(:ok)
#       end
#     end

#     context 'when user is public' do
#       it 'should return an HTTP STATUS 200' do
#         get '/api/organization/public'
#         expect(response).to have_http_status(:ok)
#       end
#     end
#   end
# end

