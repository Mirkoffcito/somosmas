module Request
    module ActivityHelpers
        def compare_activity(response, activity)
            expect(response[:activity][:name]).to eq(activity.name)
            expect(response[:activity][:content]).to eq(activity.content)
            #expect(response[:activity][:image]).to eq(activity.image)
        end

        def create_activity(attributes, token)
            post '/api/activities', headers:{
                'Authorization': token},
                :params => { activity: attributes }
        end

        def update_activity(id, token, attributes)
            put "/api/activities/#{id}", headers:{
                'Authorization': token},
                :params => { activity: attributes }
        end

        def delete_activity(id, token)
            delete "/api/activities/#{id}", headers:{
                'Authorization': token}
        end
    end
end