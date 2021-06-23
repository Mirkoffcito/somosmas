module ApiHelpers

  def login_with_api
    register_with_api
    post '/api/auth/login', params: {
      user: {
        email: "santiago@santiago.com",
        password: "santiago"
      }
    }
  end 

  def register_with_api
    post '/api/auth/register', params: {
      user: { 
        first_name: "Santiago",
        last_name: "Leon",
        email: "santiago@santiago.com",
        password: "santiago",
        password_confirmation: "santiago",
        role_id: 1
       }
    }
  end

end