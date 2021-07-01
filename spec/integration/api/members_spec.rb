require 'swagger_helper'

RSpec.describe '../integration/api/members', type: :request do

  let(:Authorization) { "Bearer #{access_token}" }

  describe 'Members API' do
  
    path '/api/members' do

      post 'Creates a member' do
    
        tags 'Members'
        consumes 'application/json'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :member, in: :body, schema: {
          type: :object,
          properties: {
            member: {
              type: :array,
              items: {
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  facebook_url: { type: :string, nullable: true },
                  linkedin_url: { type: :string, nullable: true },
                  instagram_url: { type: :string, nullable: true },
                  description: { type: :string, nullable: true }

                }
              }
            }
          },
          required: ['name']
        }
    
        response '201', 'member created' do
          schema type: :object,
            properties: {
              member: {
                type: :array,
                items:{
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    facebook_url: { type: :string, nullable: true },
                    linkedin_url: { type: :string, nullable: true },
                    instagram_url: { type: :string, nullable: true },
                    description: { type: :string, nullable: true }
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

      get 'Get all members' do
        tags 'Members'
        consumes 'application/json'
        produces 'application/json'

        response '200', 'list of members' do
          schema type: :object,
            properties: {
                members: {
                  type: :array,
                  items:{
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      facebook_url: { type: :string, nullable: true },
                      linkedin_url: { type: :string, nullable: true },
                      instagram_url: { type: :string, nullable: true },
                      description: { type: :string, nullable: true }
                    }
                  }
                }
            }
          run_test!
        end
      end
    end

    path '/api/members/{id}' do

      put 'Updates a member' do
        tags 'Members'
        security [Bearer: {}]
        produces 'application/json'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string
        parameter name: :member, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            facebook_url: { type: :string, nullable: true },
            linkedin_url: { type: :string, nullable: true },
            instagram_url: { type: :string, nullable: true },
            description: { type: :string, nullable: true }
          }
        }

        response '200', 'updated successfully' do
          schema type: :object,
            properties: {
              member: {
                type: :array,
                items:{
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    facebook_url: { type: :string, nullable: true },
                    linkedin_url: { type: :string, nullable: true },
                    instagram_url: { type: :string, nullable: true },
                    description: { type: :string, nullable: true }
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

        response '404', 'not found'do
          run_test!
        end
      end

      delete 'Delete a member' do
        tags 'Members'
        security [Bearer: {}]
        produces 'application/json'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string

        response '200', 'updated successfully' do
          run_test!
        end

        response '401', 'unauthorized' do
          run_test!
        end
        
        response '404', 'not found'do
          run_test!
        end

      end
    end
  end
  
end
