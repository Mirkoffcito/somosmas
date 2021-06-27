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
        create_list(:new, 10)
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
      let!(:article) { create(:new) }
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
        expect(json_response[:error]).to eq("news not found")
      end
    end
  end

  describe 'POST /api/news' do
    let(:attributes) { attributes_for :new }
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
        before do |example|
          attributes[:name] = 'NEW TEST'
          attributes[:content] = 'CONTENIDO TEST'
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

    end

  
  end

  describe 'PUT /api/news/:id' do
  end

  describe 'DELETE /api/news/:id' do
  end
end
