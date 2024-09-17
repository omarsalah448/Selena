require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          title: { type: :string },
          phone_number: { type: :string },
          company_attributes: {
            type: :object,
            properties: {
              name: { type: :string },
              timezone: { type: :string },
              work_week_start: { type: :string }
            }
          }
        },
        required: [ 'name', 'email', 'password', 'title', 'phone_number', 'company_attributes' ]
      }

      response '201', 'user created' do
        let(:user) { { name: 'John Doe', email: 'john@example.com', password: 'password', title: 'Manager', phone_number: '1234567890', company_attributes: { name: 'ACME Inc', timezone: 'UTC', work_week_start: 'monday' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'foo' } }
        run_test!
      end
    end
  end

  # Add other endpoints (GET, PUT, DELETE) here...
end