# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:attributes) { attributes_for :comments }
  let(:article) { create(:article) }

  describe 'GET /api/comments' do
    subject(:get_comments) { get '/api/comments' }

    context "when comment's table is empty" do
      before { get_comments }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(json_response[:comments]).to eq([])
      end
    end

    context "when comment's table is not empty" do
      let(:client_user) { create(:user, :client_user) }
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }

      let!(:article) { create(:article) }
      let!(:comments) { create_list(:comments, 5, new_id: article.id, user_id: admin_user.id) }
      let!(:comments1) { create_list(:comments, 5, new_id: article.id, user_id: client_user.id) }

      before { get_comments }
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of comments' do
        expect(json_response[:comments].length).to eq(10)
      end
    end
  end

  describe 'POST /api/comments' do
    subject(:create_comment) do
      post '/api/comments',
           headers: { 'Authorization': token },
           params: { comment: attributes }
    end

    context "when user's not logged in" do
      let(:token) { '' }
      before { create_comment }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when users's admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context 'when create a comment' do
        before do |example|
          attributes[:content] = 'CONTENIDO COMENTARIO TEST'
          attributes[:new_id] = article.id
          create_comment unless example.metadata[:skip_before]
        end

        it 'adds 1 comment to the database', :skip_before do
          expect { create_comment }.to change(Comment, :count).by(1)
        end

        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'when create an empty comment' do
        before do |example|
          attributes[:content] = ''
          attributes[:new_id] = article.id
          create_comment unless example.metadata[:skip_before]
        end

        it 'adds 1 comment to the database', :skip_before do
          expect { create_comment }.to change(Comment, :count).by(1)
        end

        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context "when can't create a comment" do
        context 'when new_id is invalid' do
          before do |example|
            attributes[:content] = 'CONTENIDO COMENTARIO TEST'
            unless example.metadata[:skip_before]
              attributes[:new_id] =
                create_comment
            end
          end

          it 'does not add a comment to the database', :skip_before do
            expect { create_comment }.not_to change(Comment, :count)
          end

          it 'returns HTTP STATUS 422' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns a message error' do
            expect(json_response[:comment]).to eq(nil)
          end
        end
      end
    end

    context 'when user is not admin' do
      let(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(client_user)
        token
        @json_response = nil
      end

      context 'when create a comment' do
        before do |example|
          attributes[:content] = 'CONTENIDO COMENTARIO TEST'
          attributes[:new_id] = article.id
          create_comment unless example.metadata[:skip_before]
        end

        it 'adds 1 comment to the database', :skip_before do
          expect { create_comment }.to change(Comment, :count).by(1)
        end

        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'when create an empty comment' do
        before do |example|
          attributes[:content] = ''
          attributes[:new_id] = article.id
          create_comment unless example.metadata[:skip_before]
        end

        it 'adds 1 comment to the database', :skip_before do
          expect { create_comment }.to change(Comment, :count).by(1)
        end

        it 'returns a HTTP STATUS 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context "when can't create a comment" do
        context 'when new_id is invalid' do
          before do |example|
            attributes[:content] = 'CONTENIDO COMENTARIO TEST'
            unless example.metadata[:skip_before]
              attributes[:new_id] =
                create_comment
            end
          end

          it 'does not add a comment to the database', :skip_before do
            expect { create_comment }.not_to change(Comment, :count)
          end

          it 'returns HTTP STATUS 422' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'returns a message error' do
            expect(json_response[:comment]).to eq(nil)
          end
        end
      end
    end
  end

  describe 'PATCH api/comments/:id' do
    subject(:updates_comment) do
      put "/api/comments/#{id}", 
      headers: { 'Authorization': token },
      params: { comment: attributes }
    end

    context "when user's not admin" do
      let(:token) { '12315123125123' }
      let(:id) { 1 }
      before { updates_comment }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's admin" do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when comment's id doesn't exist" do
        let(:id) { 4 }
        before { updates_comment }

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns a message error' do
          expect(json_response[:error]).to eq('comment not found')
        end
      end

      context "when activity's id exists and is found" do
        let!(:article) { create(:article) }
        let!(:comment) { create(:comments, new_id: article.id, user_id: admin_user.id) }
        let(:id) { comment.id }

        context 'when params are valid' do
          before do
            attributes[:content] = 'CONTENIDO NUEVO COMENTARIO TEST'
            attributes[:new_id] = article.id
            updates_comment
          end

          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end

  describe 'DELETE api/comments/:id' do
    subject(:deletes_comment) do
      delete "/api/comments/#{id}",
      headers: { 'Authorization': token }
    end

    context "when user's not admin" do
      let(:token) { '125623441231' }
      let(:id) { 1 }
      before { deletes_comment }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's admin" do
      let(:token) { json_response[:user][:token] }
      let(:admin_user) { create(:user, :admin_user) }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when comment 'id' exists" do
        let!(:comment) { create(:comments, new_id: article.id, user_id: admin_user.id) }
        let(:id) { comment.id }
        before do |example|
          deletes_comment unless example.metadata[:skip_before]
        end

        it 'removes comment from the database', :skip_before do
          expect { deletes_comment }.to change(Comment, :count).by(-1)
        end

        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when comment's 'id' doesn't exists" do
        let(:id) { '12' }
        before { deletes_comment }

        it 'returns HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns comment not found message' do
          expect(json_response[:error]).to eq('comment not found')
        end
      end
    end
  end
end
