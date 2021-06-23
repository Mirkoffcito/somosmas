# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let (:valid_params) { attributes_for :member }
  let (:new_member) { attributes_for :member }
  let (:invalid_params) { attributes_for :param_missing_member }
  let (:user_admin) { attributes_for :admin_user }
  let (:user_client) { attributes_for :client_user }

  describe '.create' do
    context 'when is valid' do
      before do
        FactoryBot.create(:admin_role)
        login_with_api(user_admin)
        post '/api/members',
          headers:
            { 'Authorization': json_response[:user][:token] },
          params:
            { member: valid_params }
      end
      it { expect(response).to have_http_status(200) }
    end

    context 'when is invalid' do
      before do
        FactoryBot.create(:admin_role)
        login_with_api(user_admin)
        post '/api/members',
          headers:
          { 'Authorization': json_response[:user][:token] },
          params: { member: invalid_params }
      end
      it { expect(response).to have_http_status(400) }
    end

    context "when user's not admin" do
      before do
        FactoryBot.create(:client_role)
        login_with_api(user_client)
        post '/api/members',
          headers:
            { 'Authorization': json_response[:user][:token] },
          params: { member: invalid_params }
      end
      it { expect(response).to have_http_status(401) }
    end
  end

  describe '.index' do
    context "when user's admin" do
      before do
        FactoryBot.create(:member)
        FactoryBot.create(:admin_role)
        login_with_api(user_admin)
        get '/api/members',
          headers:
            { 'Authorization': json_response[:user][:token] }
      end
      it 'get the resources' do
        expect(response).to have_http_status(200)
        expect(json_response[:member])
      end
    end

    context "when user's not admin" do
      before do
        FactoryBot.create(:member)
        FactoryBot.create(:client_role)
        login_with_api(user_client)
        get '/api/members',
          headers:
            { 'Authorization': json_response[:user][:token] }
      end
      it 'get the resources' do
        expect(response).to have_http_status(200)
        expect(json_response[:member])
      end
    end
  end

  describe '.update' do
    context "when user's admin" do
      before do
        @old_member = FactoryBot.create(:member)
        FactoryBot.create(:admin_role)
        login_with_api(user_admin)
        put "/api/members/#{@old_member.id}",
          headers:
            { 'Authorization': json_response[:user][:token] },
          params: { member: new_member }
      end
      it 'update the resource' do
        expect(response).to have_http_status(200)
        expect(Member.find(@old_member.id).description).to eq(new_member[:description])
      end
    end

    context "when user's not admin" do
      before do
        @old_member = FactoryBot.create(:member)
        FactoryBot.create(:client_role)
        login_with_api(user_client)
        put "/api/members/#{@old_member.id}",
          headers:
            { 'Authorization': json_response[:user][:token] },
          params: { member: new_member }
      end
      it { expect(response).to have_http_status(401) }
      it { expect(Member.find(@old_member.id)).to eq(@old_member) }
    end
  end
end
