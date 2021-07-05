# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '../integration/api/activities', type: :request do
  let(:create_activities) { create_list(:activity, 10) }
  before { create_activities }
  describe 'Activities' do
    path '/api/activities' do

      get 'Lists all activities' do
        tags ' Activities'
        produces 'application/json'

        response '200', 'lists activities' do
          schema type: :object,
            properties: {
              activities: {
                type: :array,
                items: {
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    content: { type: :string },
                    image: { type: :string }
                  },
                  required: %w[id name content]
                }
              }
            }
          run_test!
        end
      end

      post 'Creates an activity' do
        tags ' Activities'
        security [bearer_auth:{}]
        consumes 'application/json'
        produces 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :activity, in: :body, schema: { 
          type: :object,
          properties: {
            activity: {
              type: :object,
              properties: {
                name: { type: :string },
                content: { type: :string },
                image: { type: :string }
              },
              required: %w[name content]
            }
          }
        }

        response '201', 'Activity created' do
          schema type: :object,
            properties: {
              activity: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  content: { type: :string },
                  image: { type: :string }
                },
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

    path '/api/activities/{id}' do

      put 'Updates an activity' do
        tags ' Activities'
        security [bearer_auth:{}]
        consumes 'application/json'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, required: true
        parameter name: :activity, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            content: { type: :string },
            image: { type: :string }
          }
        }
        
        response '200', 'updated succesfully' do
          schema type: :object,
          properties: {
            activity: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                content: { type: :string },
                image: { type: :string }
              },
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

      delete 'Deletes an activity' do
        tags ' Activities'
        security [bearer_auth:{}]
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, required: true

        response '200', 'deleted succesfully' do
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