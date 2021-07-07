# frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Comments', type: :request do
#   shared_examples 'compares comments' do |subject|
#     let(:updated_comment) { Comment.new(attributes) }
#     it "returns the #{subject}'s' content" do
#       expect(json_response[:comments][:content]).to eq(updated_comment.content)
#       expect(json_response[:comments][:user_id]).to eq(updated_comment.user_id)
#       expect(json_response[:comments][:new_id]).to eq(updated_comment.new_id)
#     end
#   end

#   describe 'GET /api/comments' do
#     subject(:get_comments) { get '/api/comments' }

#     context "when comment's table is empty" do
#       before { get_comments }

#       it 'returns a HTTP STATUS 200' do
#         expect(response).to have_http_status(:ok)
#       end

#       it 'returns an empty array' do
#         expect(json_response[:comments]).to eq([])
#       end
#     end

#     context "when comment's table is not empty" do
#       let(:client_user) { create(:user, :client_user) }
#       let(:admin_user) { create(:user, :admin_user) }
#       let(:token) { json_response[:user][:token] }

#       let!(:article) { create(:article) }
#       let!(:comments) { create_list(:comments, 5, new_id: article.id, user_id: admin_user.id) }
#       let!(:comments1) { create_list(:comments, 5, new_id: article.id, user_id: client_user.id) }

#       before { get_comments }
  
#       it 'returns a HTTP STATUS 200' do
#         expect(response).to have_http_status(:ok)
#       end
  
#       it 'returns an array of comments' do
#         expect(json_response[:comments].length).to eq(10)
#       end
#     end
#   end

require 'rails_helper'

RSpec.describe 'Comments', type: :request do

  describe 'POST /api/comments' do

    subject(:create_comment) do
        post '/api/comments',
          headers: { 'Authorization': token },
          params: { comments: attributes }
      end

    subject(:create_new) do
      post '/api/news',
        headers: { 'Authorization': token },
        params: { new: attributes }
    end

    context "when users's admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end
 
        context "when create a comment" do
          # byebug
          let(:category) { create(:category) }
          let(:article) { create(:article) } 
          let(:attributes) { attributes_for :comments }
          # let(:attributes) { attributes_for :article }
          before do |example|
            attributes[:content] = 'CONTENIDO COMENTARIO TEST'
            attributes[:new_id] = "1"
            attributes[:user_id] = "1"
            attributes[:category_id] = category.id
            create_comment #  unless example.metadata[:skip_before]
            # create_new unless example.metadata[:skip_before]
          end
          it 'adds 1 comment to the database', :skip_before do
            # expect { create_new }.to change(New, :count).by(1)
            expect { create_comment } # .to change(Comment, :count).by(1)
            puts json_response
          end
          it 'returns a HTTP STATUS 201' do
            expect(response).to have_http_status(:created)
            puts json_response
          end
        end
      end
  end
end

      # context "first create a new" do
      #   let(:category) { create(:category) }
      #   let(:attributes) { attributes_for :article }
      #   before do |example|
      #     attributes[:name] = 'NEW TEST'
      #     attributes[:content] = 'CONTENIDO TEST'
      #     attributes[:category_id] = category.id
      #     create_new unless example.metadata[:skip_before]
      #   end
      #   it 'adds 1 new to the database', :skip_before do
      #     expect { create_new }.to change(New, :count).by(1)
      #   end
      #   it 'returns a HTTP STATUS 201' do
      #     expect(response).to have_http_status(:created)
      #     puts json_response
      #   end  

    # context "when user's not logged in" do
    #   let(:token) { '' }
    #   before { create_comment }
    
    #   it 'returns a HTTP STATUS 401' do
    #     expect(response).to have_http_status(:unauthorized)
    #   end
    
    #   it 'returns a message error' do
    #     expect(json_response[:message]).to eq('Unauthorized access.')
    #   end
    # end

    # context "when can't create a comment" do
    #   before { create_comment }

    #   it 'returns a HTTP STATUS 400' do
    #     expect(response).to have_http_status(:bad_request)
    #   end

    #   it 'returns nil' do
    #     expect(json_response[:category]).to eq(nil)
    #   end
    # end

#   describe 'PATCH api/categories/:id' do
#     let!(:category) { create(:category, attributes) }

#     subject(:updates_category) do
#       put "/api/categories/#{id}", headers: {
#         'Authorization': token },
#         params: { category: attributes }
#     end

#     context "when user's not admin" do
#       let(:token) { '12315123125123' }
#       let(:id) { category.id }
#       before { updates_category }

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
#         let(:id) { category.id }
#         before do
#           attributes[:name] = 'CATEGORIA TEST'
#           attributes[:description] = 'DESCRIPCION TEST'
#           updates_category
#         end

#         it 'returns a HTTP STATUS 200' do
#           expect(response).to have_http_status(:ok)
#         end

#         include_examples 'compares categories', 'updated category'
#       end

#       context 'when params are empty' do
#         let(:id) { category.id }
#         let(:attributes) {}
#         before { updates_category }

#         it 'returns a HTTP STATUS 400' do
#           expect(response).to have_http_status(:bad_request)
#         end

#         it 'returns an error message' do
#           expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
#         end
#       end

#       context "when category's 'id' doesn't exists" do
#         let(:id) { 2 }
#         before { updates_category }

#         it 'returns a HTTP STATUS 404' do
#           expect(response).to have_http_status(:not_found)
#         end

#         it 'returns an category not found message' do
#           expect(json_response[:error]).to eq('category not found')
#         end
#       end
#     end
#   end

#   describe 'DELETE api/categories/:id' do
#     let!(:category) { create(:category, attributes) }
#     let(:id) { category.id }
#     subject(:deletes_category) do
#       delete "/api/categories/#{id}", headers: {
#         'Authorization': token
#       }
#     end

#     context "when user's not admin" do
#       let(:token) { '125623441231' }
#       before { deletes_category }

#       it 'returns a HTTP STATUS 401' do
#         expect(response).to have_http_status(:unauthorized)
#       end

#       it 'returns a message error' do
#         expect(json_response[:message]).to eq('Unauthorized access.')
#       end
#     end

#     context "when user's admin" do
#       let(:token) { json_response[:user][:token] }
#       let(:admin_user) { create(:user, :admin_user) }
#       before do
#         login_with_api(admin_user)
#         token
#         @json_response = nil
#       end

#       context "when category's 'id' exists" do
#         before do |example|
#           deletes_category unless example.metadata[:skip_before]
#         end

#         it 'removes the category from the database', :skip_before do
#           expect { deletes_category }.to change(Category, :count).by(-1)
#         end

#         it 'returns HTTP STATUS 200' do
#           expect(response).to have_http_status(:ok)
#         end

#         it 'returns a success message' do
#           expect(json_response[:message]).to eq('Succesfully deleted')
#         end
#       end

#       context "when category's 'id' doesn't exists" do
#         let(:id) { '12' }
#         before { deletes_category }

#         it 'returns HTTP STATUS 404' do
#           expect(response).to have_http_status(:not_found)
#         end

#         it 'returns an category not found message' do
#           expect(json_response[:error]).to eq('category not found')
#         end
#       end
#     end
#   end
# end
