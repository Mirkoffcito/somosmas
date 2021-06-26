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

        it 'returns a list of all testimonials' do
          subject
          expect(json_response[:testimonials].length).to eq(5)
        end
      end

      context 'when user is registered' do
        subject { get '/api/testimonials', headers: @headers }

        context 'when user is client' do
          it 'returns a status ok' do
            login_with_api(@client_user)
            @headers = { 'Authorization' => json_response[:user][:token] }
            subject
            expect(response).to have_http_status(:ok)
          end

          it 'returns a list of all testimonials' do
            login_with_api(@client_user)
            @headers = { 'Authorization' => json_response[:user][:token] }
            subject
            expect(response.body).to include('testimonials')
          end
        end

        context 'when user is admin' do
          it 'returns a status ok' do
            login_with_api(@admin_user)
            @headers = { 'Authorization' => json_response[:user][:token] }
            subject
            expect(response).to have_http_status(:ok)
          end

          it 'returns a list of all testimonials' do
            login_with_api(@admin_user)
            @headers = { 'Authorization' => json_response[:user][:token] }
            subject
            expect(response.body).to include('testimonials')
          end
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

      context 'when user is client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user is admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'returns a status created' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'creates a new testimonial' do
          expect do
            subject
          end.to change { Testimonial.count }.by(1)
        end

        it 'returns a status bad request without params' do
          post '/api/testimonials', headers: @headers
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns a error message  with one param in blank' do
          post '/api/testimonials', params: { testimonial: { content: ' ' } }, headers: @headers
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
      context 'when user is client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          put "/api/testimonials/#{@id}", params: { testimonial: { content: 'test fail update' } }, headers: @headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user is admin' do
        before do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
        end

        it 'changes the name correctly' do
          put "/api/testimonials/#{@id}", params: { testimonial: { name: 'Other name' } }, headers: @headers
          res = JSON.parse(response.body, symbolize_names: true)
          expect(res[:testimonial][:name]).to eq('Other name')
          expect(response).to have_http_status(:ok)
        end

        it 'returns a status unprocessable entity with name in blank' do
          put "/api/testimonials/#{@id}", params: { testimonial: { name: ' ' } }, headers: @headers
          expect(response).to have_http_status(:unprocessable_entity)
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
      context 'when user is client' do
        it 'returns a status unauthorized' do
          login_with_api(@client_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when user is admin' do
        it 'returns a status ok' do
          login_with_api(@admin_user)
          @headers = { 'Authorization' => json_response[:user][:token] }
          expect(response).to have_http_status(:ok)
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
