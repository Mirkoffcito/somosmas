require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { attributes_for :user }
  
  before(:all) do
    @admin_user = create(:user, :admin_user)
    @client_user = create(:user, :client_user)
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
      
      it 'update first name: Success' do
        json_response[:user][:first_name] = 'Jose'
        @params = { "user":{ "first_name": json_response[:user][:first_name] }}
        patch "/api/users/#{@id}", :params => @params, :headers => @headers
        expect(json_response[:user][:first_name]).to eq('Jose')
      end

      it 'update first name other id: Unauthorized' do
        @client_user.first_name = 'Pedro'
        @params = { "user":{ "first_name": @client_user.first_name }}
        patch "/api/users/#{@client_user.id}", :params => @params, :headers => @headers
        expect(response.status).to eq(401)
      end

      it 'update last name with nil: bad request' do
        json_response[:user][:last_name] = ' '
        @params = { "user":{ "last_name": json_response[:user][:last_name] }}
        patch "/api/users/#{@id}", :params => @params, :headers => @headers
        expect(response.body).to include("can't be blank")
      end
    end

    context 'as client' do
      before(:each) do
        login_with_api(@client_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end
      
      it 'update first name: Success' do
        json_response[:user][:first_name] = 'Jose'
        @params = { "user":{ "first_name": json_response[:user][:first_name] }}
        patch "/api/users/#{@id}", :params => @params, :headers => @headers
        
        expect(json_response[:user][:first_name]).to eq('Jose')
      end
      
      it 'update without token: Unauthorized' do
        json_response[:user][:first_name] = Faker::Name.first_name
        @params = { "user":{ "first_name": json_response[:user][:first_name] }} 
        patch "/api/users/#{@id}", :params => @params
  
        expect(response).to have_http_status(:unauthorized)
      end

      it 'update params no valid: email is invalid ' do
        json_response[:user][:email] = 'correo-no-valido'
        @params = { "user":{ "email": json_response[:user][:email] }}
        patch "/api/users/#{@id}", :params => @params, :headers => @headers
        expect(response.body).to include("is invalid")
      end
    end
  end

  describe 'Delete /destroy' do
    context 'as admin' do
      before(:each) do
        login_with_api(@admin_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end

      it 'with token message: Succesfully deleted' do
        delete "/api/users/#{@id}", :headers => @headers
        expect(response.body).to include("Succesfully deleted")  
      end

      it 'without token' do
        delete "/api/users/#{@id}"
        expect(response.status).to eq(401)  
      end

      it 'with token for other id' do
        delete "/api/users/#{@client_user.id}", :headers => @headers
        expect(response.status).to eq(401)
      end
    end

    context 'as client' do
      before(:each) do
        login_with_api(@client_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end

      it 'with token' do
        delete "/api/users/#{@id}", :headers => @headers
        expect(response.status).to eq(200)  
      end

      it 'without token message: Unauthorized access.' do
        delete "/api/users/#{@id}"
        expect(response.body).to include("Unauthorized access.")  
      end

      it 'with token for other id' do
        delete "/api/users/#{@admin_user.id}", :headers => @headers
        expect(response.status).to eq(401)
      end
    end
  end
end
