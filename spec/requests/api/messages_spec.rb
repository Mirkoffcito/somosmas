# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:attributes) { attributes_for :messages }

  describe 'GET /api/messages/:id' do
    let(:chat) { create(:chat) }
    let(:user) { create(:user, :client_user) }
    let(:chat_user) { create(:chat_user, user_id: user.id) }
    let(:message) { create(:message, chat_id: chat.id, user_id: user.id) }

    subject(:get_message) do
      get "/api/messages/#{id}",
        headers: { 'Authorization': token }
    end

    context 'when user is not logged' do
      let(:token) { '' }
      let(:id) { message.id }

      before { get_message }
      it 'return a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when user is logged in' do
      let(:token) { json_response[:user][:token] }

      context 'when message does not exist' do
        let(:id) { 99 }
        before do
          login_with_api(user)
          token
          @json_response = nil
          get_message
        end

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(json_response[:error]).to eq('message not found')
        end

      end

      context 'when message exists' do
        let(:id) { message.id }
        
        context 'when belongs to him' do
         before do
          login_with_api(user)
          token
          @json_response = nil
          get_message
         end
  
          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
  
          it 'check message to have id, detail, chat keys' do
            expect(json_response[:message]).to have_key(:id)
            expect(json_response[:message]).to have_key(:detail)
            expect(json_response[:message]).to have_key(:chat)
          end
        end
  
        context 'when not belongs to him' do
          let(:token) { 'random_token' }
          before do
            login_with_api(user)
            @json_response = nil
            get_message
          end

          it 'returns a HTTP STATUS 401' do
            expect(response).to have_http_status(:unauthorized)
          end

          it 'returns an error message' do
            expect(json_response[:message]).to eq('Unauthorized access.')
          end

        end
        
      end
    end
  end
end
