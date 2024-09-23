require 'swagger_helper'

RSpec.describe 'Account Activations API', type: :request do
  path '/account_activations' do
    post 'Invites a new user' do
      tags 'Account Activations'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              title: { type: :string },
              phone_number: { type: :string },
              admin: { type: :boolean }
            },
            required: [ 'name', 'email', 'title', 'phone_number' ]
          }
        },
        required: [ 'user' ]
      }

      response '200', 'user invited' do
        let(:company) { create(:company) }
        let(:admin) { create(:user, :admin, company: company) }
        let(:Authorization) { "Bearer #{JwtCreater.new(user: admin).call}" }
        let(:user) do
          {
            user: {
              name: "John Doe",
              email: "john@example.com",
              title: "Developer",
              phone_number: "1234567890",
              admin: false
            }
          }
        end

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid_token' }
        let(:user) { {} }
        run_test!
      end
    end
  end

  path '/account_activations/{id}' do
    put 'Activates a user account' do
      tags 'Account Activations'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              password: { type: :string },
              password_confirmation: { type: :string },
              activation_token: { type: :string },
              device_id: { type: :string }
            },
            required: [ 'password', 'password_confirmation', 'activation_token', 'device_id' ]
          }
        },
        required: [ 'user' ]
      }

      response '200', 'user activated' do
        let(:user) { create(:user, activated: false, activation_token: "activation_token") }
        let(:id) { user.id }
        let(:user_params) do
          {
            user: {
              password: "password123",
              password_confirmation: "password123",
              activation_token: "activation_token",
              device_id: "device_123"
            }
          }
        end

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { create(:user, activated: false, activation_token: "activation_token") }
        let(:id) { user.id }
        let(:user_params) do
          {
            user: {
              password: "password123",
              password_confirmation: "password123",
              activation_token: "invalid_token",
              device_id: "device_123"
            }
          }
        end

        run_test!
      end
    end
  end
end
