# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  User.skip_callback(:create, :after, :send_mail)
  let(:attributes) { attributes_for :message }

  describe 'GET /api/messages/:id' do
    let(:chat) { create(:chat) }
    let(:user) { create(:user, :client_user) }
    let(:chat_user) { create(:chat_user, user_id: user.id, chat_id: chat.id) }
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
        
        context 'when belongs to current user' do
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
  
        context 'when not belongs to current user' do
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

  describe "GET /api/chats/:id/messages" do
    let(:token) {  json_response[:user][:token] }
    let(:sender) { create(:user, :client_user) }
    let(:receiver) { create(:user, id: 2) }
    let(:chat) { create(:chat) }
    let!(:chat_user) { create(:chat_user, user_id: sender.id, chat_id: chat.id) }
    
    subject(:get_messages) do
      get "/api/chats/#{id}/messages",
        headers: { 'Authorization': token }
    end 

    context 'when user is not logged in' do
      let(:token) { '' }
      let(:id) { 1 }
      
      before { get_messages }

      it 'return a STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when user is logged in' do
      
      before do
        login_with_api(sender)
        token
        @json_response = nil
      end

      context 'when chat does not exists' do
        let(:id) { 99 }
        before { get_messages }

        it 'returns an STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(json_response[:error]).to eq ('message not found')
        end
      end

      context 'when chat exists' do
        let(:id) { chat.id }

        context 'when there are not messages' do
          before { get_messages }
          
          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns an empty array' do
            expect(json_response[:messages]).to eq([])
          end
        end

        context 'when there are messages' do
          
          context 'when chat belongs to current user' do
            before do
              create_list(:message, 5, chat_id: chat.id, user_id: sender.id)
              create_list(:message, 5, chat_id: chat.id, user_id: receiver.id)
              get_messages
            end

            it 'returns a HTTP STATUS 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'returns a list of messages' do
              expect(json_response[:messages].count).to eq(10)
            end

            it 'checks that each message has id, detail and chat keys' do
              expect(json_response[:messages]).to all(have_key(:id))
              expect(json_response[:messages]).to all(have_key(:detail))
              expect(json_response[:messages]).to all(have_key(:chat))
            end
          end

          context 'when chat does not belongs to current user' do
            let(:token) { 'random_token' }

            before { get_messages }
  
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
  
  describe "POST /api/chats/id/messages" do
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
