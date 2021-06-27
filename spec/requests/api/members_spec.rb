# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members', type: :request do
  shared_examples 'check key' do
    it 'check that each member has keys name and description' do
      json_response[:members].each do |member|
        expect(member).to have_key(:name)
        expect(member).to have_key(:description)
      end
    end
  end

  shared_examples 'compares members' do |subject|
    let(:update_member) { Member.new(attributes) }
    it "returns the #{ subject } name and description" do
      expect(json_response[:member][:name]).to eq(update_member.name)
      expect(json_response[:member][:description]).to eq(update_member.description)
    end
  end

  let (:attributes) { attributes_for :member }

  describe "GET /api/members" do
    subject(:get_members) { get '/api/members' }

    context "when member's table is empty" do
      before { get_members }
      it 'returns an empty array' do
        expect(json_response[:members]).to eq([])
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when member's table is not empty" do
      before do
        create_list(:member, 10, attributes)
        get_members
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of members' do
        expect(json_response[:members].length).to eq(10)
      end

      it 'returns correct name and description for each member' do
        check_keys(json_response[:members])
      end
    end
  end

  describe 'POST /api/members' do
    subject(:create_member) {
      post '/api/members',
      headers:{ 'Authorization': token },
      params:{ member: attributes }
     }

    context "when user's admin'" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context 'when parameters are valid' do
        before do |example|
          attributes[:name] = 'Random name'
          attributes[:description] = 'Random description'
          create_member unless example.metadata[:skip_before]
        end

        it 'adds a member to database', :skip_before do
          expect{ create_member }.to change(Member, :count).by(1)
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:created)
        end

        include_examples 'compares members', 'created member'
      end

      context 'when parameters are invalid' do
        before do
          attributes[:name] = nil
          create_member
        end

        it 'returns a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          expect(json_response[:name]).to eq(["can't be blank"])
        end
      end
    end

    context "when user's not admin" do
      let(:token) { 'client_token' }
      before { create_member }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
  end

  describe 'PUT /api/members/:id' do
    let!(:member) { create(:member, attributes) }

    subject(:updates_member) {
      put "/api/members/#{id}",
        headers: { 'Authorization': token },
        params: { member: attributes }
    }
    context "when user's not admin" do
      let(:token) { 'client_token' }
      let(:id) { member.id }
      before { updates_member }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context 'when params are valid' do
        let(:id) { member.id }
        before do
          attributes[:name] = 'Random name'
          attributes[:description] = 'Random description'
          updates_member
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        include_examples "compares members", 'updated member'
      end

      context 'when params are empty' do
        let(:id) { member.id }
        let(:attributes) { }
        before{ updates_member }

        it 'returns a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end
    end
  end

  describe 'DELETE /api/members' do
    let (:member) { create(:member, attributes) }
    let (:id) { member.id }
    subject(:delete_member) {
      delete "/api/members/#{id}",
        headers: { 'Authorization': token }
    }
    context "when user's not admin" do
      let(:token) { 'client_token' }
      before { delete_member }
      
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when user is admin' do
      let(:token) { json_response[:user][:token] }
      let(:admin_user) { create(:user, :admin_user) }
      before do
        member
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context 'when member is deleted' do
        before do |example|
          delete_member unless example.metadata[:skip_before]
        end

        it 'deletes member from database', :skip_before do
          expect{ delete_member }.to change(Member, :count).by(-1)
        end

        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when member's not found" do
        let(:id) { 99 }
        before { delete_member }

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns a member not found message' do
          expect(json_response[:error]).to eq('member not found')
        end
      end
    end
  end
end
