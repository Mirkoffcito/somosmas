# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  shared_examples 'compares categories' do |subject|
    let(:updated_category) { Category.new(attributes) }
    it "returns the #{subject}'s' name and description" do
      expect(json_response[:category][:name]).to eq(updated_category.name)
      expect(json_response[:category][:description]).to eq(updated_category.description)
      expect(json_response[:category]).to have_key(:name)
    end
  end

  let(:attributes) { attributes_for :category }

  describe 'GET /api/categories' do
    subject(:get_categories) { get '/api/categories' }
    context "when category's table is empty" do
      before { get_categories }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(json_response[:categories]).to eq([])
      end
    end

    context "when category's table is not empty" do
      before do
        create_list(:category, 10)
        get_categories
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of categories' do
        expect(json_response[:categories].length).to eq(10)
      end

      it 'checks that each categories has keys "name"' do
        json_response[:categories].each do |category|
          expect(category).to have_key(:name)
        end
      end
    end
  end

  describe 'POST api/categories' do
    subject(:creates_category) do
      post '/api/categories',
           headers: { 'Authorization': token },
           params: { category: attributes }
    end

    context "when user's not admin" do
      let(:token) { '12312312323' }
      before { creates_category }

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
      context 'when params are valid' do
        before do |example|
          attributes[:name] = 'CATEGORIA TEST'
          attributes[:description] = 'DESCRIPCION TEST'
          creates_category unless example.metadata[:skip_before]
        end

        it 'adds 1 category to the database', :skip_before do
          expect { creates_category }.to change(Category, :count).by(1)
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:created)
        end

        include_examples 'compares categories', 'created category'
      end

      context 'when name param is blank' do
        before do
          attributes[:name] = nil
          creates_category
        end

        it 'returns a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns a message error' do
          expect(json_response[:name]).to eq(["can't be blank"])
        end
      end
    end
  end

  describe 'PATCH api/categories/:id' do
    let!(:category) { create(:category, attributes) }

    subject(:updates_category) do
      put "/api/categories/#{id}", headers: {
        'Authorization': token },
        params: { category: attributes }
    end

    context "when user's not admin" do
      let(:token) { '12315123125123' }
      let(:id) { category.id }
      before { updates_category }

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
      context 'when params are valid' do
        let(:id) { category.id }
        before do
          attributes[:name] = 'CATEGORIA TEST'
          attributes[:description] = 'DESCRIPCION TEST'
          updates_category
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        include_examples 'compares categories', 'updated category'
      end

      context 'when params are empty' do
        let(:id) { category.id }
        let(:attributes) {}
        before { updates_category }

        it 'returns a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end

      context "when category's 'id' doesn't exists" do
        let(:id) { 2 }
        before { updates_category }

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an category not found message' do
          expect(json_response[:error]).to eq('category not found')
        end
      end
    end
  end

  describe 'DELETE api/categories/:id' do
    let!(:category) { create(:category, attributes) }
    let(:id) { category.id }
    subject(:deletes_category) do
      delete "/api/categories/#{id}", headers: {
        'Authorization': token
      }
    end

    context "when user's not admin" do
      let(:token) { '125623441231' }
      before { deletes_category }

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

      context "when category's 'id' exists" do
        before do |example|
          deletes_category unless example.metadata[:skip_before]
        end

        it 'removes the category from the database', :skip_before do
          expect { deletes_category }.to change(Category, :count).by(-1)
        end

        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when category's 'id' doesn't exists" do
        let(:id) { '12' }
        before { deletes_category }

        it 'returns HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an category not found message' do
          expect(json_response[:error]).to eq('category not found')
        end
      end
    end
  end
end
