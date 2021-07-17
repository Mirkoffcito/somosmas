require 'swagger_helper'

RSpec.describe '../integration/api/messages', type: :request do
  describe 'Messages API' do
    path '/api/chats/{id}/messages' do
      
      post 'Sent a message' do
      
        tags 'Messages'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer, required: true
        parameter name: :message, in: :body, schema: {
          type: :object,
          properties: {
            message: {
              type: :object,
              items: {
                properties: {
                  detail: { type: :string }
                }
              }
            }
          },
          required: ['detail']
        }

        response '201', 'message created' do
          schema typ: :object,
            properties: {
              message: {
                type: :object,
                items: {
                  id: { type: :integer },
                  detail: { type: :string }
                }
              }
            }
            run_test!
        end

        response '401', 'aunauthorized' do
          run_test!
        end

        response '422', 'invalid request' do
          run_test!
        end

        response '400', 'bad request' do
          run_test!
        end

        response '404', 'chat not found' do
          run_test!
        end
      end
    end
  end
end