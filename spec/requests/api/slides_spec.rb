# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'slides', type: :request do
  let(:attributes) { attributes_for :slide }

  describe 'GET api/slides' do
    subject(:get_slides) { get '/api/slides' }

    # context "when slide's table is empty" do
    #   before { get_slides }

    #   it 'returns a HTTP STATUS 200' do
    #     expect(response).to have_http_status(:ok)
    #   end

    #   it 'returns an empty array' do
    #     expect(json_response[:slides]).to eq([])
    #   end
    # end

    context "when slide's table is not empty" do
      let!(:organization) { create(:organization) }
      let!(:slide) { create_list(:slide, 2, organization_id: organization.id) }
      before { get_slide }
      
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of slides' do
        expect(json_response[:slides].length).to eq(10)
      end
    end
  end
end

      # it 'checks that each categories has keys "name"' do
      #   json_response[:categories].each do |category|
      #     expect(category).to have_key(:name)
      #   end
      # end
    


#   describe 'POST api/slides' do
#     subject(:creates_slide) do
#       post '/api/slides',
#            headers: { 'Authorization': token },
#            params: { slide: attributes }
#     end

#     context "when user's not admin" do
#       let(:token) { '12312312323' }
#       before { creates_slide }

#       it 'returns a HTTP STATUS 401' do
#         expect(response).to have_http_status(:unauthorized)
#       end

#       it 'returns a message error' do
#         expect(json_response[:message]).to eq('Unauthorized access.')
#       end
#     end

#     context "when user's admin" do
#       let(:admin_user) { create(:user, :admin_user) }
#       let(:token) { json_response[:user][:token] }
#       before do
#         login_with_api(admin_user)
#         token
#         @json_response = nil
#       end
#       context 'when params are valid' do
#         before do |example|
#           attributes[:text] = 'SLIDE TEST'
#           attributes[:order] = ''
#           attributes[:image] = ''
#           attributes[:organization_id] = 1
#           creates_slide unless example.metadata[:skip_before]
#         end

#         it 'adds 1 category to the database', :skip_before do
#           expect { creates_slide }.to change(Slide, :count).by(1)
#         end

#         it 'returns a HTTP STATUS 200' do
#           expect(response).to have_http_status(:created)
#         end
#       end
#     end
#   end
# end

    #   context 'when name param is blank' do
    #     before do
    #       attributes[:name] = nil
    #       creates_category
    #     end

    #     it 'returns a HTTP STATUS 400' do
    #       expect(response).to have_http_status(:bad_request)
    #     end

    #     it 'returns a message error' do
    #       expect(json_response[:name]).to eq(["can't be blank"])
    #     end
    #   end
    # end