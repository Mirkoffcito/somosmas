require 'swagger_helper'

RSpec.describe '../integration/api/users', type: :request do
  describe 'Users API' do

    path '/api/users' do
      get 'returns all users' do
        tags 'Users'
        produces 'application/json'
        security [bearer_auth: {}]

        response '200 ', 'show all users as Admin' do
          examples 'application/json' => {
            users: [
              {
                id: 1,
                first_name: 'Guido',
                last_name: 'Medina',
                email: 'guido@gmail.com',
                role: {
                  id: 1,
                  name: 'admin',
                  description: 'null'
                },
                image: 'myprofileimage.com/image.jpg'
              },
              {
                id: 2,
                first_name: 'Antonio',
                last_name: 'Porchia',
                email: 'antonio@gmail.com',
                role: {
                  id: 1,
                  name: 'client',
                  description: 'null'
                },
                image: 'myprofileimage.com/image.jpg'
              }
            ]
          }

          schema type: :object,
          properties: {
            users: {
              type: :array,
              items: {
                properties: {
                  id: { type: :integer },
                  first_name: { type: :string },
                  last_name: { type: :string },
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

        response '200', 'show all users as Client' do
          examples 'application/json' => {
            users: [
              {
                id: 1,
                first_name: 'Guido',
                last_name: 'Medina',
              },
              {
                id: 2,
                first_name: 'Antonio',
                last_name: 'Porchia',
              }
            ]
          }

          schema type: :object,
          properties: {
            users: {
              type: :array,
              items: {
                properties: {
                  id: { type: :integer },
                  first_name: { type: :string },
                  last_name: { type: :string }
                }
              }
            }
          }
          run_test!
        end

        response '401', 'Not a logged in user' do
          run_test!
        end
      end
    end
  end
  
end