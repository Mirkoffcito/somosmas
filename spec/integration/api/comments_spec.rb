require 'swagger_helper'

RSpec.describe '../integration/api/comments', type: :request do
  describe 'Comments API' do
    path '/api/backoffice/comments' do
      get 'Get all comments' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string

        response '200', 'list all comments' do
          schema type: :object, properties:
            {
              comments: {
                type: :array, items:
                {
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
    end

    path '/api/comments' do
      post '/api/comments' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'

        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :comment, in: :body, schema: {
          type: :object, properties:
          {
            comment: {
              type: :object, items:
              {
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
          schema type: :object, properties:
          {
            comments: {
              type: :object, items:
              {
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

    path '/api/comments/{id}' do
      put 'Updates a comment' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer, required: true
        parameter name: :comment, in: :body, schema: {
          type: :object,
          properties: {
            content: { type: :string }
          }
        }

        response '200', 'updated successfully' do
          schema type: :object, properties: {
            comment: {
              type: :object,
              items: {
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

        response '404', 'not found' do
          run_test!
        end
      end
      delete 'Delete a comment' do
        tags 'Comments'
        consumes 'application/json'
        produces 'application/json'
        security [bearer_auth: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :integer, required: true

        response '200', 'deleted successfully' do
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