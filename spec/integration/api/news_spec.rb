require 'swagger_helper'

RSpec.describe '../integration/api/news', type: :request do

  describe 'News API' do
    
    path '/api/news' do
      
      get 'Get all news' do
        tags 'New'
        consumes 'application/json'
        produces 'application/json'
      
        response '200', 'List of news' do
          schema type: :object,
            properties: {
                news: {
                  type: :array,
                  items:{
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      content: { type: :text },
                      category_id: { type: :integer }
                    }
                  }
                }
            }
          run_test!
        end
      end
    
      
      post 'Creates a new' do
    
        tags 'New'
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :new, in: :body, schema: {
          type: :object,
          properties: {
            new: {
              type: :object,
              items: {
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  content: { type: :text },
                  category_id: { type: :integer }
                }
              }
            }
          },
          required: ['name']
        }
    
        response '201', 'New created' do
          schema type: :object,
            properties: {
              new: {
                type: :object,
                items:{
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    content: { type: :text },
                    category_id: { type: :integer }
                  }
                }
              }
            }
          run_test!
        end

        response '401', 'Unauthorized' do
          run_test!
        end
    
        response '422', 'Invalid request' do
          run_test!
        end
      end
    end

    path '/api/news/{id}' do

      put 'Updates a new' do
        tags 'New'
        security [Bearer: {}]
        produces 'application/json'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :id, in: :path, type: :string
        parameter name: :new, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            content: { type: :text },
            category_id: { type: :integer }
          }
        }

        response '200', 'Updated successfully' do
          schema type: :object,
            properties: {
              new: {
                type: :object,
                items:{
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    content: { type: :text },
                    category_id: { type: :integer }
                  }
                }
              }
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

      delete 'Delete a new' do
        tags 'New'
        security [Bearer: {}]
        produces 'application/json'
        consumes 'application/json'
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

    path '/api/news/:id/comments' do
      
      get 'Get all comments of a new' do
        tags 'New'
        consumes 'application/json'
        produces 'application/json'
      
        response '200', 'List of comments of a new' do
          schema type: :object,
            properties: {
                news: {
                  type: :array,
                  items:{
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      content: { type: :text },
                      category_id: { type: :integer },
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
                  }
                }
            }
          run_test!
        end
      end
    end
  end
end
