# spec/integration/blogs_spec.rb
require 'swagger_helper'

describe 'Organization' do
  path '/api/organization/public' do

    get 'Gets an Organization' do
      tags 'Organization'
      produces 'application/json'
      parameter name: :organization, in: :path, type: :string 

      response '200', 'Organization found' do
        schema type: :object,
          properties: {
              name: { type: :string },
              adress: { type: :string },
              phone: { type: :integer },
              email: { type: :string },
              welcome_text: { type: :text },
              about_us_text: { type: :text },
              facebook_url: { type: :string },
              instagram_url: { type: :string },
              linkedin_url: { type: :string }
          },
          required: ['name', 'email', 'welcome_text']

        run_test!
      end
    end

    put 'Updates an Organization' do
      tags 'Organization'
      security [bearer_auth: {}]
      consumes 'application/json'
      parameter name: :organization, in: :path, type: :string 

      response '200', 'Organization updated' do
        schema type: :object,
          properties: {
              name: { type: :string },
              adress: { type: :string },
              phone: { type: :integer },
              email: { type: :string },
              welcome_text: { type: :text },
              about_us_text: { type: :text },
              facebook_url: { type: :string },
              instagram_url: { type: :string },
              linkedin_url: { type: :string }
          },
          required: ['name', 'email', 'welcome_text']

        run_test!
      end

      response '400', 'Parameter is missing or its value is empty' do
        run_test!
      end

      response '401', 'You are not an administrator' do
        run_test!
      end

      response '401', 'Unauthorized access.' do
        run_test!
      end
    end
  end
end
