# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  let (:organization) {create(:organization)}
  let (:user_admin) { attributes_for :admin_user }
  let (:user_client) { attributes_for :client_user }

  describe 'GET /api/organization/public' do
    
    context 'with admin user' do
      before do
        FactoryBot.create(:admin)
        login_with_api(user_admin)
        get '/api/organization/public', headers:{'Authorization': json_response[:user][:token]}
      end
      it 'request with admin authorization' do
        expect(response).to have_http_status(:ok)
        expect(json_response[:organization])
      end
    end

    context 'with client_user' do
      before do
        FactoryBot.create(:member)
        FactoryBot.create(:client)
        login_with_api(user_client)
        get '/api/organization/public', headers:{'Authorization': json_response[:user][:token]}
      end
      it 'request with admin authorization' do
        expect(response).to have_http_status(:ok)
        expect(json_response[:member])
      end
    end

    context 'with public user' do
      before do
        FactoryBot.create(:client)
        login_with_api(user_client)
        get '/api/organization/public'
      end
      it 'request with public permissions' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end