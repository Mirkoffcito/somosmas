module Request
    module AuthHelpers
        def register_with_api(attributes)
            post api_auth_register_url, params: {
                user: attributes, as: :json
            }
        end

        def compare(response, user)
            expect(response[:user][:id]).to eq(user.id) if user.id
            expect(response[:user][:email]).to eq(user.email)
            expect(response[:user][:first_name]).to eq(user.first_name)
            expect(response[:user][:last_name]).to eq(user.last_name)
        end
    end
end