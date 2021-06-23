module ApiHelpers

  def login_with_api(user)
    register_with_api(user)
    post '/api/auth/login', params: {
      user: {
        email: user[:email],
        password: user[:password]
      }
    }
  end 

  def register_with_api(user)
    post '/api/auth/register', params: {
      user:{ 
        first_name: user[:first_name],
        last_name: user[:last_name],
        email: user[:email],
        password: user[:password],
        password_confirmation: user[:password_confirmation],
        role_id: user[:role_id]
       }
    }
  end

end