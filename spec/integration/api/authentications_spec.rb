require 'swagger_helper'

RSpec.describe '../integration/api/authentications', type: :request do
    describe 'Authentication' do

        path '/api/auth/register' do
            post 'Registers a new User' do
                tags 'Authentication'
                produces 'application/json'
                consumes 'application/json'

                parameter name: :user, in: :body, schema: {
                    type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                first_name: { type: :string },
                                last_name: { type: :string },
                                email: { type: :string },
                                role_id: {type: :integer},
                                image: { type: :string },
                                password: { type: :string },
                                password_confirmation: { type: :string }
                            },
                            requires: %w[first_name last_name email password password_confirmation]
                        }
                    }
                }

                response '200', 'returns new registered user' do
                    schema type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                id: { type: :integer },
                                first_name: { type: :string },
                                last_name: { type: :string },
                                email: { type: :string },
                                role: {
                                    type: :object,
                                    properties: {
                                        id: { type: :integer },
                                        name: { type: :string },
                                        description: { type: :string }
                                    }
                                },
                                image: { type: :string },
                                token: { type: :string }
                            }
                        }
                    }
                    run_test!
                end

                response '400', 'no params are sent' do
                    run_test!
                end

                response '422', 'invalid params are sent' do
                    run_test!
                end
            end
        end

        path '/api/auth/login' do
            post 'Logins a user' do
                tags 'Authentication'
                consumes 'application/json'
                produces 'application/json'

                parameter name: :user, in: :body, schema: {
                    type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                email: { type: :string },
                                password: { type: :string }
                            },
                            requires: %w[email password]
                        }
                    }
                }

                response '200', 'logins a new user' do
                    schema type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                id: { type: :integer },
                                first_name: { type: :string },
                                last_name: { type: :string },
                                email: { type: :string },
                                role: {
                                    type: :object,
                                    properties: {
                                        id: { type: :integer },
                                        name: { type: :string },
                                        description: { type: :string }
                                    }
                                },
                                image: { type: :string },
                                token: { type: :string }
                            }
                        }
                    }
                    run_test!
                end

                response '400', 'invalid params' do
                    run_test!
                end

            end
        end

        path '/api/auth/me' do
            get 'Returns the current user info' do
                tags 'Authentication'
                produces 'application/json'
                security [bearer_auth:{}]

                response '200', 'returns the current user info' do
                    schema type: :object,
                    properties: {
                        user: {
                            type: :object,
                            properties: {
                                id: { type: :integer },
                                first_name: { type: :string },
                                last_name: { type: :string },
                                email: { type: :string },
                                role: {
                                    type: :object,
                                    properties: {
                                        id: { type: :integer },
                                        name: { type: :string },
                                        description: { type: :string }
                                    }
                                },
                                image: { type: :string }
                            }
                        }
                    }
                    run_test!
                end

                response '401', 'unauthorized request' do
                    run_test!
                end
            end
        end
    end
end
