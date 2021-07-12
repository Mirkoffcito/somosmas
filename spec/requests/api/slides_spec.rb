# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'slides', type: :request do
  let!(:attributes) { attributes_for :slide }
  let!(:organization) { create(:organization) }

  # describe 'GET api/slides' do
  #   subject(:get_slides) { get '/api/slides' }

    # context "when slide's table is empty" do
    #   before { get_slides }
    #   it 'returns a HTTP STATUS 200' do
    #     expect(response).to have_http_status(:ok)
    #   end
    #   it 'returns an empty array' do
    #     expect(json_response[:slides]).to eq([])
    #   end
    # end

  #   context "when slide's table is not empty" do
  #     let!(:slide) {create_list(:slide, 2, organization_id: organization.id)}
  #     before { get_slides }
  #     it 'returns a HTTP STATUS 200' do
  #       expect(response).to have_http_status(:ok)
  #       puts json_response
  #     end
  #     it 'returns an array of slides' do
  #       expect(json_response[:slide].length).to eq(1)
  #       puts json_response
  #     end
  #   end
  # end

  describe 'POST api/slides' do
    subject(:creates_slide) do
      post '/api/slides',
           headers: { 'Authorization': token },
           params: { slide: attributes }
    end

    # context "when user's not logged" do
    #   let(:token) { '12312312323' }
    #   before { creates_slide }
    #   it 'returns a HTTP STATUS 401' do
    #     expect(response).to have_http_status(:unauthorized)
    #   end
    #   it 'returns a message error' do
    #     expect(json_response[:message]).to eq('Unauthorized access.')
    #   end
    # end

    # context "when user's not admin" do
    #   let(:client_user) { create(:user, :client_user) }
    #   let(:token) { json_response[:user][:token] }
    #   before do
    #     login_with_api(client_user)
    #     token
    #     @json_response = nil
    #     creates_slide
    #   end
    #   it 'returns a HTTP STATUS 401' do
    #     expect(response).to have_http_status(:unauthorized)
    #   end
    #   it 'returns a message error' do
    #     expect(json_response[:error]).to eq('You are not an administrator')
    #   end
    # end

    context "when user's admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end
      
      context 'when create a slide' do
        before do 
          create(:organization)
          create(:slide, organization_id: organization.id)
        end

        it 'adds 1 comment to the database' do
          expect { creates_slide }.to change(Slide, :count).by(1)
        end

        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end
     end
  end
end
