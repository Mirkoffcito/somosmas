require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:admin_user) { attributes_for :admin_user }
  let!(:client_user) { attributes_for :client_user }
  
  before(:all) do
    FactoryBot.create(:admin)
    @admin_user = create(:admin_user)
    FactoryBot.create(:client)
    @client_user = create(:client_user)
  end

  describe 'GET /index' do
    context 'colletion all users' do
      let(:users) { create_list(:user, 8) }
      context 'as admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'status 200, success' do
          get '/api/users', :headers => @headers 

          expect(response).to have_http_status(:success)
        end
        
        it 'as colletion' do
          expect(response).to respond_to(:to_a)
        end

        it 'as a collection of User objects' do
          expect(users).to all(be_instance_of User)
        end
      end
      
      context 'as client' do
        before do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end
        
        it "status 401, unauthorized" do
          get '/api/users', :headers => @headers 

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'without token' do
        it 'status 401, unauthorized' do
          get '/api/users'

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'Patch /update' do
    context 'as admin' do
      before(:each) do
        login_with_api(@admin_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end
      
      it 'update without token, unauthorized' do
        json_response[:user][:first_name] = Faker::Name.first_name
        @params = { "user":{ "first_name": json_response[:user][:first_name] }} 
        patch "/api/users/#{@id}", :params => @params

        expect(response).to have_http_status(:unauthorized)
      end
      
      it 'update first name correctly' do
        json_response[:user][:first_name] = 'Jose'
        @params = { "user":{ "first_name": json_response[:user][:first_name] }}
        patch "/api/users/#{@id}", :params => @params, :headers => @headers

        expect(json_response[:user][:first_name]).to eq('Jose')
      end
    end
  end
end
