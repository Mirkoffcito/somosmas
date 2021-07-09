require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe 'GET api/backoffice/contacts' do 
    let(:token) { json_response[:user][:token] }
    let!(:admin_user) { create(:user, :admin_user) }
    let!(:client_user) { create(:user, :client_user)}

    subject(:get_contact) do
     get '/api/backoffice/contacts' ,
           headers: { 'Authorization': token }
    end
    
    context "when user is not admin" do 
      before do
        login_with_api(client_user)
        token 
        @json_response = nil
        get_contact
      end
      
      it 'returns a unauthorized error when the user is not admin' do
       expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
      end
    end

    context "when table is empty" do
      context "the user is admin" do
        before do
          login_with_api(admin_user)
          token
          #create(:contacts)
          get_contact
        end
        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty array' do
          expect(response[:contact]).to eq(nil)
        end
      end
    end

    context "when table is not empty" do
      before do
        login_with_api(admin_user)
        token
        create_list(:contact, 10, name: 'Name', message: 'Message', email:'mail@mail', user_id: admin_user.id)
        get_contact 
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of all contacts' do  
        expect(json_response[:contacts].lenght).to eq(10)
      end
    end
  end
  describe 'POST api/contacts' do
    let(:token) { json_response[:user][:token] }
    let!(:admin_user) { create(:user, :admin_user) }
    let!(:client_user) { create(:user, :client_user)}
    let(:attributes) { attributes_for :contact }  

        subject(:create_contact) do
              post '/api/contacts',
              headers: { 'Authorization': token },
              params: { contact: attributes }
        end

  
    context "when user is logged in" do          
      let!(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(client_user)
        token
      end
      context "when params are valid" do
        before do 
          attributes[:name] = 'TEST'
          attributes[:email] = 'test@email.com'
          attributes[:message] = 'MESSAGE'
          create_contact 
        end
        it 'adds 1 contacts to the database' do
          expect { create_new }.to change(Contact, :count).by(1)
        end
        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end
      context "when params are invalid" do
        before do |example|
          attributes[:name] = 'Test'
          attributes[:message] = 'Message'
          attributes[:email] = ''
          create_new unless example.metadata[:skip_before]
        end

        it 'returns HTTP STATUS 400', :skip_before do
          expect(response).to have_http_status(:bad_request)
        end
        it 'does not add a new to the database', :skip_before do
          expect { create_contact }.not_to change(Contact, :count)
        end
      end
    end
  end


    
    # describe "GET /my_contacts" do
    #   let(:token) { json_response[:user][:token] }
    #   let!(:admin_user) { create(:user, :admin_user) }
    #   let!(:client_user) { create(:user, :client_user)}

    #   before do
      #   login_with_api(user)
      #   token
      #   let(:user) { owner }
      #   get_my_contact
    #   end


    #   subject(:get_my_contact) do
    #     get '/api/my_contacts' ,
    #     headers: { 'Authorization': token }
    #   end
        
    #   context "when user is not the owner" do    
    #     it 'returns a unauthorized error' do
    #       expect(response).to have_http_status(:unauthorized)
    #     end
    #   end

    #   context "when table is empty" do

    #     it 'returns a HTTP STATUS 200' do
    #       expect(response).to have_http_status(:ok)
    #     end

    #     it 'returns an empty array' do
    #       expect(json_response[:contacts]).to eq([])
    #     end
    #   end 

    #   context "when table is not empty" do
    #     it 'return the number of the contacts in my array' do 
    #       create_list(:contact, 10)
    #       expect(json_response[:contacts].count).to eq(10)
    #     end 
    #     it 'returns a HTTP STATUS 200' do
    #       expect(response).to have_http_status(:ok)
    #     end

    #     it 'returns an array of my contacts' do
    #       let(:contact) { FactoryBot.create(:contact, owner: owner) }
    #       create_list(:contact, 10)
    #       expect(json_response[:contacts].count).to eq(10)
    #       #  expect(json_response[:contacts].owner).to eq(??))
    #     end
    #   end
    # end    
end


