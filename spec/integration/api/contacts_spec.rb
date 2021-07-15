# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '../integration/api/contacts', type: :request do
  let(create_contacts) { create_list(:contact, 10) }
  before {create_contacts }
  describe 'Contacts' do
    path '/api/backoffice/contacts' do

        get 'Lists all contacts' do
            tags ' Contacts'
            produces 'application/json'
            parameter name: :Authorization, in: :header, type: :string
            response '200', 'lists contacts' do
            schema type: :object,
                properties: {
                contacts: {
                    type: :array,
                    items: {
                    properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        message: { type: :string },
                        created_at: { type: :string }
                    },
                    required: %w[id name content]
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
      post 'Creates an contact' do
        tags ' Activities'
        security [bearer_auth:{}]
        consumes 'application/json'
        produces 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :contact, in: :body, schema: { 
          type: :object,
          properties: {
            contact: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                message: { type: :string }
              },
              required: %w[id name message created_at]
            }
          }
        }

        response '201', 'Activity created' do
          schema type: :object,
            properties: {
              contact: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  message: { type: :string },
                  user_id { type: :integer }
          
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

    get 'Lists my contacts' do
        tags ' Contacts '
        produces 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        response '200', 'lists contacts' do
          schema type: :object,
            properties: {
              contacts: {
                type: :array,
                items: {
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    message: { type: :string },
                    created_at: { type: :string }
                  },
                  required: %w[id name message created_at]
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
end