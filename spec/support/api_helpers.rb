module Request
  module ApiHelpers
    def login_with_api(user)
      post api_auth_login_url, params: {
        user: {
          email: user.email,
          password: user.password
          }
        }
    end
  end
end