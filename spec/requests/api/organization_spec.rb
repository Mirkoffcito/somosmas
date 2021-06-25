# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  let (:attributes) { attributes_for :organization }

  describe 'GET /api/organization/public' do
    # context "when organization's table is empty" do
    #   before { get '/api/organization/public' }
    #   it 'does return a HTTP STATUS 200' do
    #     expect(response).to have_http_status(:ok)
    #   end
    #   it 'does return an empty array' do
    #     expect(json_response[:organization]).to eq([])
    #   end
    # end

    context "when organization's table is not empty" do
      before do
        create(:organization)
        get '/api/organization/public'
      end
      it 'does return a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'does return an Organization' do
        expect(json_response[:organization].length).to eq(10)
      end
      it 'Organization does have a name, email and welcome_text' do
        check_keys(json_response[:organization])
      end
    end
  end

  describe 'PATCH /api/organization/public' do
    before { @organization = create(:organization, attributes) }

    context "when user's not admin" do
      before do
        client_user = create(:user, :client_user)
        login_with_api(client_user)
        @token = json_response[:user][:token]
        @json_response = nil
        update_organization(attributes, @token)
      end
      it 'does return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does return a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
      end
    end

    context "when user's not registered" do
      before { update_organization(attributes, '') }
      it 'does return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does return a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's admin" do
      before do
        admin_user = create(:user, :admin_user)
        login_with_api(admin_user)
        @token = json_response[:user][:token]
        @json_response = nil
      end
    
      context 'when params are valid' do
        before { update_organization(attributes, @token) }
        it 'does return a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end
        it 'does return the updated organization' do
          updated_organization = Organization.new(attributes)
          compare_organization(json_response, updated_organization)
        end
      end

      context 'when params are empty' do
        before { update_organization('', @token) }
        it 'does return a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end
        it 'does return an error message' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end
    end
  end
end