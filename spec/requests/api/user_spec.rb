require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { attributes_for :user }
  
  before(:all) do
    @admin_user = create(:user, :admin_user)
    @client_user = create(:user, :client_user)
  end

  describe 'GET /index' do
    context 'when users is logged' do
      subject { get '/api/users', :headers => @headers }
      let!(:users) { create_list(:user, 8) }

      context "when user's admin" do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns a status OK' do
          subject
          expect(response).to have_http_status(:success)
        end
        
        it 'respond to method .to_a' do
          subject
          expect(response).to respond_to(:to_a)
        end
        
        it 'is a collection of User objects' do
          subject
          expect(users).to all(be_instance_of User)
        end

        it 'returns a list of all users' do
         subject
         expect(users.length).to eq(8)
        end

        it 'status 401, unauthorized' do
          get '/api/users'
          expect(response).to have_http_status(:unauthorized)
        end
      end
      
      context "when user's client" do
        before do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end
        
        it "returns message: You are not an administrator" do
          subject
          expect(response.body).to include("You are not an administrator")
        end
      end
    end
  end

  describe 'Patch /update' do
    subject { patch "/api/users/#{@id}", :params => @params, :headers => @headers }

    context "when user's logged" do
      before(:each) do
        login_with_api(@admin_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end
      
      it 'first name changed correctly' do
        json_response[:user][:first_name] = 'Jose'
        @params = { "user":{ "first_name": json_response[:user][:first_name] }}
        subject
        expect(json_response[:user][:first_name]).to eq('Jose')
        expect(response.status).to eq(200)
      end

      it "returns error: Last name can't be blank / bad request status" do
        json_response[:user][:last_name] = ' '
        @params = { "user":{ "last_name": json_response[:user][:last_name] }}
        subject
        expect(response.body).to include("can't be blank")
        expect(response.status).to eq(400)
      end

      it 'returns error: email is invalid / bad request status' do
        json_response[:user][:email] = 'correo-no-valido'
        @params = { "user":{ "email": json_response[:user][:email] }}
        subject
        expect(response.body).to include("is invalid")
        expect(response.status).to eq(400)
      end

      it 'returns unauthorized status if not pass token' do
        json_response[:user][:first_name] = Faker::Name.first_name
        @params = { "user":{ "first_name": json_response[:user][:first_name] }} 
        patch "/api/users/#{@id}", :params => @params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns status 404 and User not found' do
        @client_user.first_name = 'Pedro'
        @params = { "user":{ "first_name": @client_user.first_name }}
        patch "/api/users/#{@client_user.id}", :params => @params, :headers => @headers
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'Delete /destroy' do
    context "when user's logged" do
      before(:each) do
        login_with_api(@client_user)
        @id = json_response[:user][:id]
        @headers = { 'Authorization' => json_response[:user][:token] }
      end

      it 'with token message: Succesfully deleted / success status' do
        delete "/api/users/#{@id}", :headers => @headers
        expect(response.body).to include("Succesfully deleted")
        expect(response.status).to eq(200) 
      end

      it 'without token message: Unauthorized access. / status 401' do
        delete "/api/users/#{@id}"
        expect(response.body).to include("Unauthorized access.") 
        expect(response.status).to eq(401)  
      end
      
      it 'with token for other id: User not found / status 404' do
        delete "/api/users/#{@admin_user.id}", :headers => @headers
        expect(response.body).to include("User not found")
        expect(response.status).to eq(404)
      end
    end
  end
end
