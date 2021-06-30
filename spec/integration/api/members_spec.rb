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
            name: { type: :string },
            facebook_url: { type: :string },
            linkedin_url: { type: :string },
            instagram_url: { type: :string },
            description: { type: :string }
          },
          required: ['name']
        }
    
        response '201', 'member created' do
          let(:member) { { name: 'foo' } }
          run_test!
        end

        response '401', 'unauthorized' do
          let(:Authorization) {}
          run_test!
        end
    
        response '422', 'invalid request' do
          let(:member) {}
          run_test!
        end
      end
    end
  end
  
end
