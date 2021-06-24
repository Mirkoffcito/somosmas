require 'rails_helper'

RSpec.describe "Activities", type: :request do
    let (:attributes) {attributes_for :activity}

    describe "GET activities" do
        
        context 'when there are no activities in the database' do

            before do
                get api_activities_url
            end

            it 'should return a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'should return an empty array' do
                expect(json_response[:activities]).to eq([])
            end

        end

        context 'when there are activities in the database' do

            before do
                10.times do create(:activity, attributes) end
                get api_activities_url
            end

            it 'should return a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'should return an array of activities' do
                expect(json_response[:activities]).to be_an_instance_of(Array)
            end

            it 'each activity should have a name, content and image' do
                expect(json_response[:activities].first).to have_key(:name)
                expect(json_response[:activities].first).to have_key(:content)
                expect(json_response[:activities].first).to have_key(:image)
            end
        end
    end

    describe "POST api/activities" do

        context 'when a NON-ADMIN user tries to POST' do

            before do
                create_activity(attributes, "1234567")
            end
        
            it 'should return a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'should return a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        
        end

        context 'when an ADMIN user tries to POST' do
            before do
                admin_user = create(:admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end
            context 'when it succesfully POSTS' do

                before do
                    create_activity(attributes, @token)
                end

                it 'should return a HTTP STATUS 200' do
                    expect(response).to have_http_status(:created)
                end

                it "should return the created activity's name, content and image" do
                    activity = Activity.new(attributes)
                    compare_activity(json_response, activity)
                end
            end

            context 'when it fails to POST because of bad params being sent' do
                before do
                    attributes[:name] = nil
                    create_activity(attributes, @token)
                end
                
                it 'should return a HTTP STATUS 400' do
                    expect(response).to have_http_status(:bad_request)
                end
            end
        end
    end

    describe "PUT api/activities/:id" do
        before {@activity = create(:activity, attributes)}

        context 'when a NON-ADMIN tries to UPDATE an activity' do
            before {update_activity(@activity.id, '1234', attributes)}

            it 'should return a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'should return a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end

        context 'when an ADMIN user UPDATES an activity' do
            before do
                admin_user = create(:admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end
            context 'when update is succesful' do
                before{ update_activity(@activity.id, @token, attributes) }
                it 'should return a HTTP STATUS 200' do
                    expect(response).to have_http_status(:ok)
                end

                it "should return the activity's updated info" do
                    updated_activity = Activity.new(attributes)
                    compare_activity(json_response, updated_activity)
                end
            end

            context 'when update fails because no params are sent' do
                before{ update_activity(@activity.id, @token, '') }

                it 'should return a HTTP STATUS 400' do
                    expect(response).to have_http_status(:bad_request)
                end

                it 'should return an error message' do
                    expect(json_response[:error]).to eq("Parameter is missing or its value is empty")
                end
            end
        end
    end

    describe "DELETE api/activities/:id" do
        before do
            @activity = create(:activity, attributes)
        end

        context 'when a NON-ADMIN tries to DELETE an activity' do
            before {delete_activity(@activity.id, '123512323')}
            it 'should return a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'should return a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end

    end
end