# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Testimonials', type: :request do
  let!(:user) { attributes_for :user }

  before(:all) do
    @admin_user = create(:user, :admin_user)
    @client_user = create(:user, :client_user)
  end

  describe 'GET /api/testimonials' do
    context 'endpoint public' do
      let!(:testimonials) { create_list(:testimonial, 5) }

      context 'when user is not registered' do
        subject { get '/api/testimonials' }

        it 'returns a status ok' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list with all of comments' do
          subject
          expect(json_response[:testimonials].length).to eq(5)
        end
      end

      context 'when user is registered' do
        subject { get '/api/testimonials', headers: @headers }

        it 'as client returns a status ok' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list with all of comments' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response.body).to include('testimonials')
        end

        it 'as admin returns a status ok' do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list with all of comments' do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response.body).to include('testimonials')
        end
      end
    end
  end

  describe 'POST /api/testimonials' do
    let!(:testimonial) { attributes_for :testimonial }

    context 'when user is not registered' do
      it 'returns a status unauthorized' do
        post '/api/testimonials', params: { testimonial: testimonial }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is registered' do
      subject { post '/api/testimonials', params: { testimonial: testimonial }, headers: @headers }

      context 'as client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'as admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns a status created' do
          post '/api/testimonials', params: { testimonial: testimonial }, headers: @headers
          expect(response).to have_http_status(:created)
        end

        it 'creates a new testimonial' do
          expect do
            subject
          end.to change { Testimonial.count }.by(1)
        end

        it 'without params returns a status 400' do
          post '/api/testimonials', headers: @headers
          expect(response.status).to eq(400)
        end

        it "with a param in blank returns message can't be blank" do
          post '/api/testimonials', params: { testimonial: { content: 'prueba de falla' } }, headers: @headers
          expect(response.body).to include("can't be blank")
        end
      end
    end
  end

  describe 'UPDATE /api/testimonials/:id' do
    let(:testimonial) { create(:testimonial) }
    before do
      @id = testimonial[:id]
    end

    context 'when user is not registered' do
      it 'returns a status unauthorized' do
        put "/api/testimonials/#{@id}", params: { testimonial: { content: 'test fail update' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is registered' do
      context 'as client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          put "/api/testimonials/#{@id}", params: { testimonial: { content: 'test fail update' } }, headers: @headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'as admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns name changed to: Other name' do
          put "/api/testimonials/#{@id}", params: { testimonial: { name: 'Other name' } }, headers: @headers
          res = JSON.parse(response.body, symbolize_names: true)
          expect(res[:testimonial][:name]).to eq('Other name')
          expect(response.status).to eq(200)
        end

        it 'returns unprocessable_entity status with name in blank ' do
          put "/api/testimonials/#{@id}", params: { testimonial: { name: ' ' } }, headers: @headers
          expect(response.message).to eq('Unprocessable Entity')
        end
      end
    end
  end

  describe 'DELETE /api/testimonials/:id' do
    let(:testimonial) { create(:testimonial) }
    subject { delete "/api/testimonials/#{@id}", headers: @headers }
    before do
      @id = testimonial[:id]
    end

    context 'when user is not registered' do
      it 'returns a status unauthorized' do
        delete "/api/testimonials/#{@id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is registered' do
      context 'as client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'as admin' do
        it 'returns a status success' do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:success)
        end

        it 'deletes a testimonial' do
          expect do
            subject
          end.to change { Testimonial.count }.by(0)
        end
      end
    end
  end
end
