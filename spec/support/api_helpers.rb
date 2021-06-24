module Request
  module ApiHelpers
    def login_with_api(user)
      post '/api/auth/login', params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end 
  end
end
