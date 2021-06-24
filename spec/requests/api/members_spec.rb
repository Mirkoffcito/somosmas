# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let (:attributes) { attributes_for :member }

  describe '.index' do
    context "when member's table is empty" do
      before { get '/api/members' }

      it 'does return a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'does return an empty array' do
        expect(json_response[:members]).to eq([])
      end
    end

    context "when member's table is not empty" do
      before do
        create_list(:member, 10, attributes)
        get '/api/members'
      end

      it 'does return a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'does return an array of members' do
        expect(json_response[:members].length).to eq(10)
      end

      it 'each member does have a name and description' do
        check_keys(json_response[:members])
      end
    end
  end

  describe '.create' do
    context "when user's admin'" do
      before do
        admin_user = create(:admin_user)
        login_with_api(admin_user)
        @token = json_response[:user][:token]
        @json_response = nil
      end

      context 'when parameters are valid' do

        before do |example|
          create_member(attributes, @token) unless example.metadata[:skip_before]
        end

        it 'does add a member to database', :skip_before do
          expect{ create_member(attributes, @token) }.to change(Member, :count).by(1)
        end

        it 'does return a HTTP STATUS 200' do
          expect(response).to have_http_status(:created)
        end

        it 'does return the created member' do
          member = Member.new(attributes)
          compare_member(json_response, member)
        end
      end

      context 'when parameters are invalid' do
        before do
          attributes[:name] = nil
          create_member(attributes, @token)
        end

        it 'does return a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

      end
    end

    context "when user's not admin" do
      before { create_member(attributes, 'client_token') }

      it 'does return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does return a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
  end

  describe '.update' do
    before { @member = create(:member, attributes) }

    context "when user's not admin" do
      before { update_member(@member.id, attributes, 'client_token') }

      it 'does return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does return a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's admin" do
      before do
        admin_user = create(:admin_user)
        login_with_api(admin_user)
        @token = json_response[:user][:token]
        @json_response = nil
      end

      context 'when params are valid' do
        before { update_member(@member.id, attributes, @token) }

        it 'does return a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the updated member' do
          updated_member = Member.new(attributes)
          compare_member(json_response, updated_member)
        end
      end

      context 'when params are empty' do
        before { update_member(@member.id, '', @token) }

        it 'does return a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'does return an error message' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end
    end
  end

  describe '.destroy' do
    before { @member = create(:member, attributes) }

    context "when user's not admin" do
      before { delete_member(@member.id, 'client_token') }

      it 'does return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does return an error message' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when user is admin' do
      before do
        admin_user = create(:admin_user)
        login_with_api(admin_user)
        @token = json_response[:user][:token]
        @json_response = nil
      end

      context 'when member is deleted' do
        before do |example|
          delete_member(@member.id, @token) unless example.metadata[:skip_before]
        end

        it 'does delete member from database', :skip_before do
          expect{ delete_member(@member.id, @token) }.to change(Member, :count).by(-1)
        end

        it 'does return HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when member's not found" do
        before { delete_member(99, @token) }

        it 'does return a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return a member not found message' do
          expect(json_response[:error]).to eq('member not found')
        end
      end
    end
  end
end
