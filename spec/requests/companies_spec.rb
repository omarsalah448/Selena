require 'swagger_helper'

RSpec.describe 'Companies API', type: :request do
  path '/companies' do
    get 'Retrieves all companies' do
      tags 'Companies'
      produces 'application/json'

      response '200', 'companies found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              timezone: { type: :string },
              start_day: { type: :integer }
            },
            required: [ 'id', 'name', 'timezone', 'start_day' ]
          }

        run_test!
      end
    end

    post 'Creates a company' do
      tags 'Companies'
      consumes 'application/json'
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          timezone: { type: :string },
          start_day: { type: :integer }
        },
        required: [ 'name', 'timezone', 'start_day' ]
      }

      response '201', 'company created' do
        let(:company) { { name: 'ACME Inc', timezone: 'UTC', start_day: 1 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:company) { { name: 'A' } }
        run_test!
      end
    end
  end

  path '/companies/{id}' do
    get 'Retrieves a company' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'company found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            timezone: { type: :string },
            start_day: { type: :integer }
          },
          required: [ 'id', 'name', 'timezone', 'start_day' ]

        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', start_day: 1).id }
        run_test!
      end

      response '404', 'company not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a company' do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          timezone: { type: :string },
          start_day: { type: :integer }
        }
      }

      response '200', 'company updated' do
        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', start_day: 1).id }
        let(:company) { { name: 'ACME Corp', timezone: 'GMT' } }
        run_test!
      end

      response '404', 'company not found' do
        let(:id) { 'invalid' }
        let(:company) { { name: 'ACME Corp' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', start_day: 1).id }
        let(:company) { { name: 'A' } }
        run_test!
      end
    end

    delete 'Deletes a company' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'company deleted' do
        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', start_day: 1).id }
        run_test!
      end

      response '404', 'company not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end