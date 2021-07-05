require 'swagger_helper'

describe 'Categories' do

  path '/api/categories' do

    post 'Post a category' do 
      tags 'Categories'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :categories, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
        },
        required: ['name']
      }
   
        response '201', 'Category created' do
            let(:categories) { { title: 'foo', description: 'bar' } }
          run_test!
        end

        response '401', 'Unauthorized' do
          run_test!
        end
    
        response '422', 'Invalid request' do
          run_test!
        end
      end

      get 'Get all categories' do
        tags 'Categories'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string

        response '200', 'List of categories' do
          parameter name: :categories, in: :body, schema: {
                type: :object,
                properties: {
                  name: { type: :string },
                  description: { type: :string },
                },
                required: ['name']
            }

            let(:categories) { Category.create(title: 'foo', description: 'bar').id }
          run_test!
        end
      end
    end

  path '/api/categories/{id}' do

    put 'Updates a category' do
      tags 'Categories'
      security [Bearer: {}]
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :categories, in: :body, schema: {
        type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string },
          }
        }

      response '200', 'Updated successfully' do
        parameter name: :categories, in: :body, schema: {
          type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
            },
          required: ['name']
        }
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end
    
      response '422', 'Invalid request' do
        run_test!
      end

      response '404', 'Not found'do
        run_test!
      end
    end

    delete 'Delete a category' do
      tags 'Categories'
      security [Bearer: {}]
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'Deleted successfully' do
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end    

      response '404', 'Not found'do
        run_test!
      end
    end
  end
end
