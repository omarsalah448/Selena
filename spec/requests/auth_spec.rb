require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/login' do
    post 'Authenticates user and returns JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :auth, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              device_id: { type: :string }
            },
            required: %w[email password device_id]
          }
        }
      }

      response '200', 'user authenticated' do
        let(:company) { Company.create(name: "ACME Inc", timezone: "UTC", start_day: "monday") }
        let(:user) { User.create(name: "John Doe", email: "john@example.com", password: "password", title: "Manager", phone_number: "1234567890", company: company) }
        let(:auth) { { email: user.email, password: "password", device_id: "device123" } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']).to include('name' => 'John Doe', 'email' => 'john@example.com')
          expect(data['token']).to be_present
        end
      end

      response '401', 'invalid credentials' do
        let(:auth) { { email: "wrong@example.com", password: "wrongpassword", device_id: "device123" } }
        run_test!
      end

      response '422', 'invalid parameters' do
        let(:auth) { { email: "john@example.com", password: "password" } }
        run_test!
      end
    end
  end

  path '/logout' do
    delete 'Logs out user by destroying device token' do
      tags 'Authentication'
      security [ bearerAuth: [] ]

      response '200', 'user logged out' do
        let(:company) { Company.create(name: "ACME Inc", timezone: "UTC", start_day: "monday") }
        let(:user) { User.create(name: "John Doe", email: "john@example.com", password: "password", title: "Manager", phone_number: "1234567890", company: company) }
        let(:token) { JwtCreater.new(user: user, device_id: "device123").call }
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          expect(response.body).to include("Logged out successfully")
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end
  end
end