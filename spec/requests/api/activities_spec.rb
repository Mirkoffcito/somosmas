require 'rails_helper'

RSpec.describe "Activities", type: :request do
    let (:attributes) {attributes_for :activity}

    describe "GET activities" do
        
        context 'when there are no activities in the database' do

            before{ get '/api/activities' }

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
                get '/api/activities'
            end

            it 'should return a HTTP STATUS 200' do
                expect(response).to have_http_status(:ok)
            end

            it 'should return an array of activities' do
                expect(json_response[:activities].length).to eq(10)
            end

            it 'each activity should have a name, content and image' do
                check_keys(json_response[:activities])
            end
        end
    end

    describe "POST api/activities" do

        context 'when a NON-ADMIN user tries to POST' do

            before{ create_activity(attributes, "1234567") }
        
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
            context 'when POST is succesful' do

                before do |example|
                    unless example.metadata[:skip_before]
                        create_activity(attributes, @token)
                    end
                end

                it 'should add 1 activity to the database', :skip_before do
                    expect{create_activity(attributes, @token)}.to change(Activity, :count).by(1)
                end

                it 'should return a HTTP STATUS 200' do
                    expect(response).to have_http_status(:created)
                end

                it "should return the created activity's name, content and image" do
                    activity = Activity.new(attributes)
                    compare_activity(json_response, activity)
                end
            end

            context 'when POST fails because of bad params' do
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
            before { update_activity(@activity.id, '1234', attributes) }

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
            context 'when UPDATE is succesful' do
                before{ update_activity(@activity.id, @token, attributes) }
                it 'should return a HTTP STATUS 200' do
                    expect(response).to have_http_status(:ok)
                end

                it "should return the activity's updated info" do
                    updated_activity = Activity.new(attributes)
                    compare_activity(json_response, updated_activity)
                end
            end

            context 'when UPDATE fails because no params are sent' do
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

        before{ @activity = create(:activity, attributes) }

        context 'when a NON-ADMIN tries to DELETE an activity' do

            before {delete_activity(@activity.id, '123512323')}

            it 'should return a HTTP STATUS 401' do
                expect(response).to have_http_status(:unauthorized)
            end

            it 'should return a message error' do
                expect(json_response[:message]).to eq("Unauthorized access.")
            end
        end

        context 'when an ADMIN tries to DELETE an activity' do
            before do
                admin_user = create(:admin_user)
                login_with_api(admin_user)
                @token = json_response[:user][:token]
                @json_response = nil
            end

            context 'when activity is succesfully deleted' do
                before do |example|
                    unless example.metadata[:skip_before]
                        delete_activity(@activity.id, @token)
                    end
                end

                it 'should remove the activity from the database', :skip_before do
                    expect{delete_activity(@activity.id, @token)}.to change(Activity, :count).by(-1)
                end

                it 'should return HTTP STATUS 200' do
                    expect(response).to have_http_status(:ok)
                end

                it 'should return a success message' do
                    expect(json_response[:message]).to eq("Succesfully deleted")
                end

            end

            context "when activity is not found" do
                before { delete_activity(100, @token) }

                it 'should return HTTP STATUS 404' do
                    expect(response).to have_http_status(:not_found)
                end

                it 'should return an activity not found message' do
                    expect(json_response[:error]).to eq("activity not found")
                end
            end
        end
    end
end