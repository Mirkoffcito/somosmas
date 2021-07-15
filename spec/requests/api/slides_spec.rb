# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Slides', type: :request do
  let!(:attributes) { attributes_for :slide }
  let!(:organization) { create(:organization) }

  describe 'GET api/slides' do
    subject(:get_slides) { get '/api/slides' }

    context "when slide's table is empty" do
      before { get_slides }
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns an empty array' do
        expect(json_response[:slides]).to eq([])
      end
    end

    context "when slide's table is not empty" do
      let!(:slide) {create(:slide, organization_id: organization.id)}
      before { get_slides }
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns an array of slides' do
        expect(json_response[:slides].length).to eq(1)
      end
    end
  end

  describe 'GET /api/slides/:id' do
    subject(:get_slide) { get "/api/slides/#{id}" }
    context 'when slide exists' do
      let!(:slide) {create(:slide, organization_id: organization.id)}
      let(:id) { slide.id }
      before { get_slide }
      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when slide doesn't exist" do
      let(:id) { 3 }
      before { get_slide }
      it 'returns a HTTP STATUS 404' do
        expect(response).to have_http_status(:not_found)
      end
      it 'returns a message error' do
        expect(json_response[:error]).to eq('slide not found')
      end
    end
  end


  describe 'POST api/slides' do
    subject(:creates_slide) do
      post '/api/slides',
           headers: { 'Authorization': token },
           params: { slide: attributes }
    end

    context "when user's not logged" do
      let(:token) { '12312312323' }
      before { creates_slide }
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's not admin" do
      let(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(client_user)
        token
        @json_response = nil
        creates_slide
      end
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
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
      
      context 'when create a slide' do
        context 'with valid params' do
          before do |example|
            attributes[:organization_id] = organization.id
            creates_slide unless example.metadata[:skip_before]
          end
          it 'adds 1 slide to the database', :skip_before do
            expect { creates_slide }.to change(Slide, :count).by(1)
          end
          it 'returns a HTTP STATUS 201' do
            expect(response).to have_http_status(:created)
          end
        end

        context 'with invalid organization' do
          before do |example|
            attributes[:organization_id] = 2
            creates_slide unless example.metadata[:skip_before]
          end
          it 'does not add a slide to the database', :skip_before do
            expect { creates_slide }.not_to change(Slide, :count)
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

  describe 'PATCH /api/slides/:id' do
    subject(:updates_slide) do
      put "/api/slides/#{id}", 
      headers: { 'Authorization': token },
      params: { slide: attributes }
    end

    context "when user's not logged" do
      let(:token) { '12315123125123' }
      let(:id) { 1 }
      before { updates_slide }
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's not admin" do
      let(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      let(:id) { 1 }
      before do
        login_with_api(client_user)
        token
        @json_response = nil
        updates_slide
      end
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
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

      context "when slide's id doesn't exist" do
        let(:id) { 4 }
        before { updates_slide}
        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end
        it 'returns a message error' do
          expect(json_response[:error]).to eq('slide not found')
        end
      end

      context "when slide's id exists and is found" do
        let!(:slide) {create(:slide, organization_id: organization.id)}
        let(:id) { slide.id }

        context 'when params are valid' do
          before do
            attributes[:text] = 'TEXTO NUEVO SLIDE TEST'
            attributes[:organization_id] = organization.id
            updates_slide
          end

          it 'returns a HTTP STATUS 200' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with invalid organization' do
          before do |example|
            attributes[:organization_id] = 2
            updates_slide unless example.metadata[:skip_before]
          end
          it 'does not add a slide to the database', :skip_before do
            expect { updates_slide }.not_to change(Slide, :count)
          end
          it 'returns HTTP STATUS 422' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          it 'returns a message error' do
            expect(json_response[:update]).to eq(nil)
          end
        end
      end
    end
  end

  describe 'DELETE api/slides/:id' do
    subject(:deletes_slide) do
      delete "/api/slides/#{id}",
      headers: { 'Authorization': token }
    end

    context "when user's not logged" do
      let(:token) { '12315123125123' }
      let(:id) { 1 }
      before { deletes_slide }
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context "when user's not admin" do
      let(:client_user) { create(:user, :client_user) }
      let(:token) { json_response[:user][:token] }
      let(:id) { 1 }
      before do
        login_with_api(client_user)
        token
        @json_response = nil
        deletes_slide
      end
      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns a message error' do
        expect(json_response[:error]).to eq('You are not an administrator')
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

      context "when slide 'id' exists" do
        let!(:slide) {create(:slide, organization_id: organization.id)}
        let(:id) { slide.id }
        before do |example|
          deletes_slide unless example.metadata[:skip_before]
        end
        it 'removes a slide from the database', :skip_before do
          expect { deletes_slide }.to change(Slide, :count).by(-1)
        end
        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end
        it 'returns a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when slide's 'id' doesn't exists" do
        let(:id) { '12' }
        before { deletes_slide }

        it 'returns HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns slide not found message' do
          expect(json_response[:error]).to eq('slide not found')
        end
      end
    end
  end
end
