require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  let!(:attributes) { attributes_for :contact }

  describe 'GET api/backoffice/contacts' do

    subject(:get_contacts) do
     get '/api/backoffice/contacts' ,
     headers: { 'Authorization': token },
     params: {contact: attributes}
    end

    context 'when user is not logged in' do
      let(:token) { '' }
      before { get_contacts }
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
    
    context "when user is not admin" do 
      let!(:client_user) { create(:user, :client_user)}
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(client_user)
        token 
        @json_response = nil
        get_contacts
      end
      
      it 'returns a unauthorized error when the user is not admin' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
      end
    end

    context "the user is admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
        get_contacts
      end

      context "when the table is empty" do
        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty array' do
          expect(json_response[:contact]).to eq(nil)
        end
      end

      context 'when table is not empty' do
          let(:contact) { create_list(:contact, 3, name: 'Name', message: 'Message', email:'mail@mail', user_id: admin_user.id) }
          before { get_contacts }
          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
          it 'returns all contacts' do
            expect(json_response[:contacts].length).to eq(3)
          end
      end
    end
  end 

  describe 'POST api/contacts' do

    subject(:create_contact) do
      post '/api/contacts',
          headers: { 'Authorization': token },
          params: { contact: attributes }
    end

    context 'when user is not logged in' do
      let(:token) { '' }
      before { create_contact }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end
  
    context "when user is logged in" do 
      context "and the user is admin" do         
        let!(:admin_user) { create(:user, :admin_user) }
        let(:token) { json_response[:user][:token] }
        before do
          login_with_api(admin_user)
          token
        end
        context "when params are valid" do
          before do |example|
            attributes[:name] = 'TEST'
            attributes[:email] = 'test@email.com'
            attributes[:message] = 'MESSAGE'
            create_contact unless example.metadata[:skip_before]
          end
          it 'adds 1 contacts to the database', :skip_before do
            expect{ create_contact }.to change(Contact, :count).by(1)
          end
          it 'returns a HTTP STATUS 201' do
            expect(response).to have_http_status(:created)
          end
        end
        context "when params are invalid" do
          before do |example|
            attributes[:name] = ''
            attributes[:message] = 'MENSAJE'
            attributes[:email] = 'test@mail.com'
            create_contact unless example.metadata[:skip_before]
          end

          it 'returns HTTP STATUS 400', :skip_before do
            expect(response).to have_http_status(:bad_request)
          end
          it 'does not add a contact to the database', :skip_before do
            expect { create_contact }.not_to change(Contact, :count)
          end
        end
      end
    end

    context 'user is client'do
      let!(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(client_user)
        token
      end
      context "when params are valid" do
        before do |example|
          attributes[:name] = 'TEST'
          attributes[:email] = 'test@email.com'
          attributes[:message] = 'MESSAGE'
          create_contact unless example.metadata[:skip_before]
        end
        it 'adds 1 contacts to the database', :skip_before do
          expect{ create_contact }.to change(Contact, :count).by(1)
        end
        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end
      context "when params are invalid" do
        before do |example|
          attributes[:name] = ''
          attributes[:message] = 'MENSAJE'
          attributes[:email] = 'test@mail.com'
          create_contact unless example.metadata[:skip_before]
        end

        it 'returns HTTP STATUS 400', :skip_before do
          expect(response).to have_http_status(:bad_request)
        end
        it 'does not add a contact to the database', :skip_before do
          expect { create_contact }.not_to change(Contact, :count)
        end
      end
    end
  end

  describe "GET /my_contacts" do

    let(:token) { json_response[:user][:token] } # gets the token
    let(:decoded) { JsonWebToken.decode(token) } # decodes it
    let(:current_user) { User.find(decoded[:user_id]) } # findes the user from the token

    subject(:get_my_contacts) do
      get '/api/my_contacts' ,
      headers: { 'Authorization': token }
    end

    context "when user is not the owner" do
      before do
        login_with_api(current_user)
        get_my_contacts
      end    
      it 'returns a unauthorized error' do
        let(:token) { '' }
        create_list(:contact, 3, :attributes)
        expect(response).to have_http_status(:unauthorized)
      end
    end 

    context 'when it`s the owner' do

      before do
        attributes[:user_id] = current_user.id
        login_with_api(current_user)
        token
        get_my_contacts
      end 
    
      it 'validates that the current user is the contacts owner' do
        let(:contact1) { create(:contacts, :attributes) }
        expect(Contact.user_id).to eq(current_user.id)
        byebug
      end

      context "when table is empty" do

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty array' do
          expect(json_response[:contacts]).to eq(nil)
        end
      end 

      context "when table is not empty" do
        let!(:contact) {create_list(:contact, 4, user_id: current_user.id )}
        
        it 'return the number of the contacts in my array' do 
          expect(json_response[:contacts].count).to eq(4)
        end 
        it 'returns a HTTP STATUS 200' do     
          expect(response).to have_http_status(:ok)
        end
      end 
    end
  end 
end
