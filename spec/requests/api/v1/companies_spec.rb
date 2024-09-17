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
              work_week_start: { type: :string }
            },
            required: [ 'id', 'name', 'timezone', 'work_week_start' ]
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
          work_week_start: { type: :string }
        },
        required: [ 'name', 'timezone', 'work_week_start' ]
      }

      response '201', 'company created' do
        let(:company) { { name: 'ACME Inc', timezone: 'UTC', work_week_start: 'monday' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:company) { { name: 'foo' } }
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
            work_week_start: { type: :string }
          },
          required: [ 'id', 'name', 'timezone', 'work_week_start' ]

        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0).id }
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
          work_week_start: { type: :string }
        }
      }

      response '200', 'company updated' do
        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0).id }
        let(:company) { { name: 'ACME Corp', timezone: 'GMT' } }
        run_test!
      end

      response '404', 'company not found' do
        let(:id) { 'invalid' }
        let(:company) { { name: 'ACME Corp' } }
        run_test!
      end
    end

    delete 'Deletes a company' do
      tags 'Companies'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'company deleted' do
        let(:id) { Company.create(name: 'ACME Inc', timezone: 'UTC', work_week_start: 0).id }
        run_test!
      end

      response '404', 'company not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end