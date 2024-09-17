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

  path '/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            title: { type: :string },
            phone_number: { type: :string },
            role: { type: :string },
            company_id: { type: :integer }
          },
          required: [ 'id', 'name', 'email', 'title', 'phone_number', 'role' ]

        let(:id) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', title: 'Manager', phone_number: '1234567890', company: Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0)).id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          title: { type: :string },
          phone_number: { type: :string },
          company_id: { type: :string }
        }
      }

      response '200', 'user updated' do
        let(:id) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', title: 'Manager', phone_number: '1234567890', company: Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0)).id }
        let(:user) { { name: 'Jane Doe', title: 'Senior Manager' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        let(:user) { { name: 'Jane Doe' } }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'user deleted' do
        let(:id) { User.create(name: 'John Doe', email: 'john@example.com', password: 'password', title: 'Manager', phone_number: '1234567890', company: Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0)).id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end