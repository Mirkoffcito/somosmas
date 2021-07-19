# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:attributes) { attributes_for :message }

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
  
  describe "PUT /api/chats/:id/messages" do
    let(:chat) { create(:chat) }
    let(:chat_user) { create(:chat_user, user_id: user.id) }
    let(:message) { create(:message, chat_id: chat.id, user_id: user.id) }

    subject(:update_message) do
      patch "/api/chats/#{id}/messages",
        headers: { 'Authorization': token },
        params: { message: attributes }
    end

    # context "when user's not logged in" do
    #   let(:token) { '' }
    #   let(:id) { 1 }

    #   before { update_message }

    #   it 'returns a HTTP STATUS 401' do
    #     expect(response).to have_http_status(:unauthorized)
    #   end

    #   it 'returns an error message' do
    #     expect(json_response[:message]).to eq('Unauthorized access.')
    #   end
    # end
    
    context 'when user is logged' do
      let(:user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      
      # context 'when message id does not exist' do
      #   let(:id) { 99 }

      #   before do
      #     login_with_api(user)
      #     token
      #     @json_response = nil
      #     update_message
      #   end

      #   it 'returns a HTTP STATUS 404' do
      #     expect(response).to have_http_status(:not_found)
      #   end

      #   it 'returns an error message' do
      #     expect(json_response[:error]).to eq('message not found')
      #   end
      # end

      context 'when message id exists' do
        let(:id) { message.id }
        
        # context 'when trying to update a message from another person' do
        #   let(:token) { 'random_token' }
        #   before do
        #     login_with_api(user)
        #     @json_response = nil
        #     update_message
        #   end

        #   it 'returns a HTTP STATUS 401' do
        #     expect(response).to have_http_status(:unauthorized)
        #   end

        #   it 'returns an error message' do
        #     expect(json_response[:message]).to eq('Unauthorized access.')
        #   end
        # end

        # context 'when trying to update a message that is not the last one' do
        #   let(:id) { 1 }
        #   before do
        #     login_with_api(user)
        #     token
        #     @json_response = nil
        #     update_message
        #   end

        #   it 'returns a HTTP STATUS 404' do
        #     expect(response).to have_http_status(:not_found)
        #   end

        #   it 'returns an error message' do
        #     expect(json_response[:error]).to eq('message not found')
        #   end
        # end

        context 'when owner updates with params' do
          before do
            login_with_api(user)
            token
            @json_response = nil
            attributes[:detail] = 'DETAIL TEST'
            update_message
          end

          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when owner updates with empty params' do
          let(:id) { message.id }
          let(:attributes) {}
          
          before do |example|
           login_with_api(user)
           token
           @json_response = nil
           update_message
          end

          it 'returns a HTTP STATUS 400' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns a message error' do
            expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
          end
        end
      end
    end
  end
end 
