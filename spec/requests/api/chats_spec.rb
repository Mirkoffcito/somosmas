require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let(:attributes) { attributes_for :chat }

  describe 'GET api/chats' do
    subject(:get_chats) do
     get '/api/chats' ,
     headers: { 'Authorization': token }
    end

    context 'when user is not logged in' do
      let(:token) { '' }
      before { get_chats }

      it 'returns a HTTP STATUS 401' do
       expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user is not admin" do 
      let!(:client_user) { create(:user, :client_user)}
      let(:chat) { create(:chat) }
      let(:user1) { create(:chat_user, :with_client_user, chat_id:chat.id) }
      let(:user2) { create(:chat_user, :with_client_user, chat_id:chat.id) }
      let(:token) { json_response[:user][:token] }

      before do
        login_with_api(client_user)
        token 
        @json_response = nil
      end

      context "when the table is empty" do
        before { get_chats }

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty array' do
          expect(json_response[:chats]).to eq([])
        end
      end

      context 'when table is not empty' do

        before do
          create_list(:chat, 3, attributes)
          get_chats
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all chats' do
          expect(json_response[:chats].length).to eq(3)
        end
      end
    end

    context "when the user is admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }

      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when the table is empty" do
        before { get_chats }

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty array' do
          expect(json_response[:chats]).to eq([])
        end
      end

      context 'when table is not empty' do

        before do
          create_list(:chat, 3, attributes)
          get_chats
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all chats' do
          expect(json_response[:chats].count).to eq(3)
        end
      end 
    end 

    context 'when the user is a participant in the chat' do
      let!(:chats) { create_list(:chat,3) }
      let(:user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] } # gets the token
      let(:decoded) { JsonWebToken.decode(token) } # decodes it
      let(:current_user) { User.find(decoded[:user_id]) } # findes the user from the token

      before do
        login_with_api(user)
        token
        @json_response = nil 
        get_chats
      end 

      it 'validates that the current user is the chats owner' do 
        # byebug
        expect(json_response[:chats].each do |chat|
          expect(chat[:user_id]).to eq(current_user.id)
        end
        )
      end 
    end
  end
end
