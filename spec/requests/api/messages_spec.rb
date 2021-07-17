# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:attributes) { attributes_for :messages }

  describe "POST /api/chats/#{@id}/messages" do
    subject(:create_message) do
      post "/api/chats/#{@id}/messages",
        headers: { 'Authorization': token },
        params: { message: attributes }
    end

    context "when user's not logged in" do
      let(:token) { '' }
      before do
        @id = 1
        create_message
      end

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when user is logged' do

      let(:user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      let(:chat) { create(:chat) }
      let!(:chat_user) { create(:chat_user, user_id: user.id, chat_id: chat.id) }

      context 'when chat exists' do
        before do |example|
          login_with_api(user)
          token
          @id = chat.id
          @json_response = nil
          create_message unless example.metadata[:skip_before]
        end
        
        it 'adds 1 message to the database', :skip_before do
          expect { create_message }.to change(Message, :count).by(1)
        end
  
        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'when chat does not exist' do
        before do |example|
          login_with_api(user)
          token
          @id = 99
          @json_response = nil
          create_message unless example.metadata[:skip_before]
        end
        
        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'keeps database the same', :skip_before do
          expect { create_message }.to change(Message, :count).by(0)
        end
        
      end
    end
  end
end
