# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  shared_examples 'compares news' do |subject|
    let(:updated_new) { New.new(attributes) }
    it "returns the #{subject}'s name, content and image" do
      expect(json_response[:new][:name]).to eq(updated_new.name)
      expect(json_response[:new][:content]).to eq(updated_new.content)
      expect(json_response[:new]).to have_key(:image)
    end
  end

  describe 'GET /api/news' do
    subject(:get_news) { get '/api/news' }
    context 'when there are no news in the database' do
      before { get_news }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(json_response[:news]).to eq([])
      end
    end

    context 'when there are news in the database' do
      before do
        create_list(:article, 10)
        get_news
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of news' do
        expect(json_response[:news].length).to eq(10)
      end

      it 'checks that each new has keys "name", "content" and "image"' do
        json_response[:news].each do |article|
          expect(article).to have_key(:name)
          expect(article).to have_key(:content)
          expect(article).to have_key(:image)
        end
      end
    end
  end

  describe 'GET /api/news/:id' do
    subject(:get_new) { get "/api/news/#{id}" }
    context 'when new exists' do
      let!(:article) { create(:article) }
      let(:id) { article.id }
      before { get_new }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it "returns the new's name, content and image " do
        expect(json_response[:new]).to have_key(:name)
        expect(json_response[:new]).to have_key(:content)
        expect(json_response[:new]).to have_key(:image)
      end
    end

    context " when new doesn't exist" do
      let(:id) { 3 }
      before { get_new }
      it 'returns a HTTP STATUS 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message error' do
        expect(json_response[:error]).to eq('news not found')
      end
    end
  end

  describe 'POST /api/news' do
    let(:attributes) { attributes_for :article }
    subject(:create_new) do
      post '/api/news',
           headers: { 'Authorization': token },
           params: { new: attributes }
    end

    context 'when a NON-ADMIN user tries to create a new' do
      let(:token) { '123124123152' }
      before { create_new }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN user tries to create a new' do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context 'when params are valid' do
        let!(:category) { create(:category) }
        before do |example|
          attributes[:name] = 'NEW TEST'
          attributes[:content] = 'CONTENIDO TEST'
          attributes[:category_id] = category.id
          create_new unless example.metadata[:skip_before]
        end

        it 'adds 1 new to the database', :skip_before do
          expect { create_new }.to change(New, :count).by(1)
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:created)
        end

        include_examples 'compares news', 'created new'
      end

      context 'when category_id param is invalid' do
        before do |example|
          attributes[:name] = 'NEW TEST'
          attributes[:content] = 'CONTENIDO TEST'
          attributes[:category_id] = 4
          create_new unless example.metadata[:skip_before]
        end

        it 'does not add a new to the database', :skip_before do
          expect { create_new }.not_to change(New, :count)
        end

        it 'returns HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns a message error' do
          expect(json_response[:category]).to eq(['must exist'])
        end
      end

      context 'when name param is invalid' do
        let!(:category) { create(:category) }
        before do |example|
          attributes[:name] = ''
          attributes[:content] = 'CONTENIDO TEST'
          attributes[:category_id] = category.id
          create_new unless example.metadata[:skip_before]
        end

        it 'does not add a new to the database', :skip_before do
          expect { create_new }.not_to change(New, :count)
        end

        it 'returns HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns a message error' do
          expect(json_response[:name]).to eq(["can't be blank"])
        end
      end
    end
  end

  describe 'PUT /api/news/:id' do
    let(:attributes) { attributes_for :article }
    subject(:update_new) do
      put "/api/news/#{id}",
          headers: { 'Authorization': token },
          params: { new: attributes }
    end

    context 'when a NON ADMIN user tries to update an activity' do
      let(:token) { '123124123152' }
      let(:id) { 3 }
      before { update_new }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN user tries to update an activity' do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when activity's id doesn't exist" do
        let(:id) { 4 }
        before { update_new }
        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns a message error' do
          expect(json_response[:error]).to eq('news not found')
        end
      end

      context "when activity's id exists and is found" do
        let!(:category) { create(:category) }
        let!(:article) { create(:article) }
        let(:id) { article.id }
        context 'when invalid params are sent' do
          before do
            attributes[:name] = ''
            attributes[:category_id] = category.id
            update_new
          end

          it 'returns a HTTP STATUS 400' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          it 'returns a message error' do
            expect(json_response[:name]).to eq(["can't be blank"])
          end
        end

        context 'when valid params are sent' do
          before do
            attributes[:name] = 'TESTING NEW'
            attributes[:category_id] = category.id
            update_new
          end

          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end

          include_examples 'compares news', 'updated activity'
        end
      end
    end
  end

  describe 'DELETE /api/news/:id' do
    let(:attributes) { attributes_for :article }
    let!(:article) { create(:article, attributes) }
    let(:id) { article.id }
    subject(:deletes_new) do
      delete "/api/news/#{id}", headers: {
        'Authorization': token
      }
    end
    context 'when a NON-ADMIN tries to DELETE a new' do
      let(:token) { '125623441231' }
      before { deletes_new }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN tries to delete a new' do
      let(:token) { json_response[:user][:token] }
      let(:admin_user) { create(:user, :admin_user) }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context " when new's id is found" do
        before do |example|
          deletes_new unless example.metadata[:skip_before]
        end

        it 'removes the new from the database', :skip_before do
          expect { deletes_new }.to change(New, :count).by(-1)
        end

        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a success message' do
          expect(json_response[:message]).to eq('Successfully deleted')
        end
      end

      context "when new's id is not found" do
        let(:id) { 12 }
        before { deletes_new }

        it 'returns HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns a new not found message' do
          expect(json_response[:error]).to eq('news not found')
        end
      end
    end
  end

  describe 'GET /api/news/:id/comments' do
    let(:attributes) { attributes_for :article }
    let!(:article) { create(:article, attributes) }
    let(:id) { article.id }
    subject(:get_comments) do
      get "/api/news/#{id}/comments",
          headers: { 'Authorization': token }
    end
    context " when a NON ADMIN user tries to get a new's comments" do
      let(:token) { '12312541223' }
      before { get_comments }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when an ADMIN user tries to get a new's comments " do
      let(:token) { json_response[:user][:token] }
      let!(:admin_user) { create(:user, :admin_user) }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when new's id is found" do
        context 'when new has no comments' do
          before { get_comments }
          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
          it 'returns an empty array' do
            expect(json_response[:comments]).to eq([])
          end
        end

        context 'when new has comments' do
          let(:comment_attributes) { attributes_for :comments }
          before do
            comment_attributes[:new_id] = article.id
            comment_attributes[:user_id] = admin_user.id
            create_list(:comments, 10, new_id: article.id, user_id: admin_user.id)
            get_comments
          end

          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns an array of comments for the new' do
            expect(json_response[:comments].length).to eq(10)
          end
        end
      end

      context "when new's id is not found" do
        let(:id) { 3 }
        before { get_comments }
        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns a message error' do
          expect(json_response[:error]).to eq('news not found')
        end
      end
    end
  end
end
