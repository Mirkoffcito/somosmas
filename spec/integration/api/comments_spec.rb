require 'swagger_helper'

RSpec.describe '../integration/api/comments', type: :request do

  describe 'Comments API' do
  
    path '/api/comments' do
      get 'Get all comments' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth:{}]
        parameter name: :Authorization, in: :header, type: :string

        response '200', 'list all comments' do
          schema type: :object,
            properties: {
              comments: {
                type: :array,
                items:{
                  properties: {
                    id: { type: :integer },
                    content: { type: :string }
                  }
                }
              }
            }
          run_test!
        end

        response '401', 'unauthorized' do
          run_test!
        end
      end

      post '/api/comments' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'

        security [bearer_auth:{}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :comment, in: :body, schema: {
          type: :object,
          properties: {
            comment: {
              type: :object,
              items:{
                properties: {
                  id: { type: :integer },
                  content: { type: :string },
                  new_id: { type: :integer }
                }
              }
            },
            required: ['new_id']
          }
        }
        
        response '201', 'comment created' do
          schema type: :object,
            properties: {
              comments: {
                type: :object,
                items:{
                  properties: {
                    id: { type: :integer },
                    content: { type: :string }
                  }
                }
              }
            }
          run_test!
        end

        response '401', 'unauthorized' do
          run_test!
        end
    
        response '422', 'invalid request' do
          run_test!
        end
      end
    end
  end
end