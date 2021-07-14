require 'swagger_helper'

RSpec.describe '../integration/api/users', type: :request do
  describe 'Users API' do
    
    path '/api/users/{id}' do
    
      get 'Get user' do
        tags 'Users'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string
        
        response '200', 'show user details' do
          schema type: :object,
            properties: {
              users: {
                type: :array,
                items: {
                  properties: {
                    id: { type: :integer },
                    first_name: { type: :string },
                    last_name: { type: :string },
                    email: { type: :string },
                    role: { type: :object,
                      items: {
                        id: { type: :integer },
                        name: { type: :string },
                        description: { type: :string }
                      }  
                    },
                    image: { type: :string }
                  }
                }
              }
            }
            run_test!
        end
        
        response '401', 'unauthorized' do
          run_test!
        end

        response '404', 'not found' do
          run_test!
        end
      end
    end
  end
  
end
