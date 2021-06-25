module Request
    module AuthHelpers
        def compare_user(response, user)
            expect(response[:user][:id]).to eq(user.id) if user.id
            expect(response[:user][:email]).to eq(user.email)
            expect(response[:user][:first_name]).to eq(user.first_name)
            expect(response[:user][:last_name]).to eq(user.last_name)
        end
    end
end