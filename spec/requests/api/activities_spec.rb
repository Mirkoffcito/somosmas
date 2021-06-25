require 'rails_helper'

# Custom method used here (compare_activity, check_keys,
# create_activity, update_activity, delete_activity)
# are found inside /spec/support/activity_helpers.rb

RSpec.describe "Activities", type: :request do
    let (:attributes) {attributes_for :activity}

    describe "GET activities" do
        subject(:get_news) { get '/api/activities' }
        context 'when there are no activities in the database' do

            #before{ get '/api/activities' }
            before {get_news}
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
                get_news
            end

            it 'returns a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'returns an array of activities' do
                expect(json_response[:activities].length).to eq(10)
            end

            it 'checks that each activity has keys "name", "content" and "image"' do
                check_keys(json_response[:activities])
            end
        end
    end

    describe "POST api/activities" do

        context 'when a NON-ADMIN user tries to POST' do

            before{ create_activity(attributes, "1234567") }
        
            it 'returns a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        
        end

        context 'when an ADMIN user tries to POST' do
            before do
                admin_user = create(:user, :admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end
            context 'when POST is succesful' do

                before do |example|
                    create_activity(attributes, @token) unless example.metadata[:skip_before]
                end

                it 'adds 1 activity to the database', :skip_before do
                    expect{create_activity(attributes, @token)}.to change(Activity, :count).by(1)
                end

                it 'returns a HTTP STATUS 200' do
                    expect(response).to have_http_status(:created)
                end

                it "returns the created activity's name, content and image" do
                    activity = Activity.new(attributes)
                    compare_activity(json_response, activity)
                end
            end

            context 'when POST fails because of bad params' do
                before do
                    attributes[:name] = nil
                    create_activity(attributes, @token)
                end
                
                it 'returns a HTTP STATUS 400' do
                    expect(response).to have_http_status(:bad_request)
                end
            end
        end
    end

    describe "PUT api/activities/:id" do
        before {@activity = create(:activity, attributes)}

        context 'when a NON-ADMIN tries to UPDATE an activity' do
            before { update_activity(@activity.id, '1234', attributes) }

            it 'returns a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end

        context 'when an ADMIN user UPDATES an activity' do
            before do
                admin_user = create(:user, :admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end
            context 'when correct params are sent' do
                before{ update_activity(@activity.id, @token, attributes) }
                it 'should return a HTTP STATUS 200' do
                    expect(response).to have_http_status(:ok)
                end

                it "returns the activity's updated info" do
                    updated_activity = Activity.new(attributes)
                    compare_activity(json_response, updated_activity)
                end
            end

            context 'when no params are sent' do
                before{ update_activity(@activity.id, @token, '') }

                it 'returns a HTTP STATUS 400' do
                    expect(response).to have_http_status(:bad_request)
                end

                it 'returns an error message' do
                    expect(json_response[:error]).to eq("Parameter is missing or its value is empty")
                end
            end

            context " when activity's 'id' is not found " do
                before{ update_activity(2, @token, attributes) }

                it 'returns a HTTP STATUS 404' do
                    expect(response).to have_http_status(:not_found)
                end

                it 'returns an activity not found message' do
                    expect(json_response[:error]).to eq("activity not found")
                end
            end
        end
    end

    describe "DELETE api/activities/:id" do

        before{ @activity = create(:activity, attributes) }

        context 'when a NON-ADMIN tries to DELETE an activity' do

            before {delete_activity(@activity.id, '123512323')}

            it 'returns a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'returns a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end

        context 'when an ADMIN tries to DELETE an activity' do
            before do
                admin_user = create(:user, :admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end

            context "when activity's id is found" do
                before do |example|
                    delete_activity(@activity.id, @token) unless example.metadata[:skip_before]
                end

                it 'removes the activity from the database', :skip_before do
                    expect{delete_activity(@activity.id, @token)}.to change(Activity, :count).by(-1)
                end

                it 'returns HTTP STATUS 200' do
                    expect(response).to have_http_status(:ok)
                end

                it 'returns a success message' do
                    expect(json_response[:message]).to eq("Succesfully deleted")
                end

            end

            context "when activity's 'id' is not found" do
                before { delete_activity(100, @token) }

                it 'returns HTTP STATUS 404' do
                    expect(response).to have_http_status(:not_found)
                end

                it 'returns an activity not found message' do
                    expect(json_response[:error]).to eq("activity not found")
                end
            end
        end
    end
end