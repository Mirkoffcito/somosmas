# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Activities', type: :request do
  shared_examples 'compares activities' do |subject|
    let(:updated_activity) { Activity.new(attributes) }
    it "returns the #{subject}'s' name, content and image" do
      updated_activity.name = 'ACTIVIDAD TEST'
      updated_activity.content = 'CONTENIDO TEST'
      expect(json_response[:activity][:name]).to eq(updated_activity.name)
      expect(json_response[:activity][:content]).to eq(updated_activity.content)
      expect(json_response[:activity]).to have_key(:image)
    end
  end

  let(:attributes) { attributes_for :activity }

  describe 'GET activities' do
    subject(:get_activities) { get '/api/activities' }
    context 'when there are no activities in the database' do
      before { get_activities }

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(json_response[:activities]).to eq([])
      end
    end

    context 'when there are activities in the database' do
      before do
        create_list(:activity, 10)
        get_activities
      end

      it 'returns a HTTP STATUS 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an array of activities' do
        expect(json_response[:activities].length).to eq(10)
      end

      it 'checks that each activity has keys "name", "content" and "image"' do
        json_response[:activities].each do |activity|
          expect(activity).to have_key(:name)
          expect(activity).to have_key(:content)
          expect(activity).to have_key(:image)
        end
      end
    end
  end

  describe 'POST api/activities' do
    subject(:creates_activity) do
      post '/api/activities',
           headers: { 'Authorization': token },
           params: { activity: attributes }
    end

    context 'when a NON-ADMIN user tries to POST' do
      let(:token) { '12312312323' }
      before { creates_activity }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN user tries to POST' do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end
      context 'when POST is succesful' do
        before do |example|
          attributes[:name] = 'ACTIVIDAD TEST'
          attributes[:content] = 'CONTENIDO TEST'
          creates_activity unless example.metadata[:skip_before]
        end

        it 'adds 1 activity to the database', :skip_before do
          expect { creates_activity }.to change(Activity, :count).by(1)
        end

        it 'returns a HTTP STATUS 200' do
          expect(response).to have_http_status(:created)
        end

        include_examples 'compares activities', 'created activity'
      end

      context 'when POST fails because of bad params' do
        before do
          attributes[:name] = nil
          creates_activity
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

  describe 'PUT api/activities/:id' do
    let!(:activity) { create(:activity, attributes) }

    subject(:updates_activity) do
      put "/api/activities/#{id}", headers: {
        'Authorization': token
      },
                                   params: { activity: attributes }
    end

    context 'when a NON-ADMIN tries to UPDATE an activity' do
      let(:token) { '12315123125123' }
      let(:id) { activity.id }
      before { updates_activity }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN user UPDATES an activity' do
      let(:admin_user) { create(:user, :admin_user) }
      let(:token) { json_response[:user][:token] }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end
      context 'when correct params are sent' do
        let(:id) { activity.id }
        before do
          attributes[:name] = 'ACTIVIDAD TEST'
          attributes[:content] = 'CONTENIDO TEST'
          updates_activity
        end

        it 'should return a HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        include_examples 'compares activities', 'updated activity'
      end

      context 'when no params are sent' do
        let(:id) { activity.id }
        let(:attributes) {}
        before { updates_activity }

        it 'returns a HTTP STATUS 400' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          expect(json_response[:error]).to eq('Parameter is missing or its value is empty')
        end
      end

      context " when activity's 'id' is not found " do
        let(:id) { 2 }
        before { updates_activity }

        it 'returns a HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an activity not found message' do
          expect(json_response[:error]).to eq('activity not found')
        end
      end
    end
  end

  describe 'DELETE api/activities/:id' do
    let!(:activity) { create(:activity, attributes) }
    let(:id) { activity.id }
    subject(:deletes_activity) do
      delete "/api/activities/#{id}", headers: {
        'Authorization': token
      }
    end

    context 'when a NON-ADMIN tries to DELETE an activity' do
      let(:token) { '125623441231' }
      before { deletes_activity }

      it 'returns a HTTP STATUS 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns a message error' do
        expect(json_response[:message]).to eq('Unauthorized access.')
      end
    end

    context 'when an ADMIN tries to DELETE an activity' do
      let(:token) { json_response[:user][:token] }
      let(:admin_user) { create(:user, :admin_user) }
      before do
        login_with_api(admin_user)
        token
        @json_response = nil
      end

      context "when activity's id is found" do
        before do |example|
          deletes_activity unless example.metadata[:skip_before]
        end

        it 'removes the activity from the database', :skip_before do
          expect { deletes_activity }.to change(Activity, :count).by(-1)
        end

        it 'returns HTTP STATUS 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a success message' do
          expect(json_response[:message]).to eq('Succesfully deleted')
        end
      end

      context "when activity's 'id' is not found" do
        let(:id) { '12' }
        before { deletes_activity }

        it 'returns HTTP STATUS 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an activity not found message' do
          expect(json_response[:error]).to eq('activity not found')
        end
      end
    end
  end
end
