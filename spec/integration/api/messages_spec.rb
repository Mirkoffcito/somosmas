require 'swagger_helper'

RSpec.describe '../integration/api/messages', type: :request do
  describe 'Messages API' do
    path '/api/messages/{id}' do
      get 'Get a message details' do
        tags 'Messages'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer, required: true

        response '200', 'ok' do
          schema type: :object,
          properties: {
            message: {
              type: :object,
              items: {
                id: { type: :integer },
                detail: { type: :string },
                chat: {
                  type: :object,
                  items: {
                    id: {type: :integer }
                  }
                }
              }
            }
          }
          run_test!
        end

        response '404', 'message not found' do
          run_test!
        end

        response '401', 'unauthorized' do
          run_test!
        end

      end
    end
    
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
          schema type: :object,
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

        response '401', 'unauthorized' do
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