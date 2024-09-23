require "swagger_helper"

RSpec.describe "Vacations API", type: :request do
  let(:user) { create(:user) }
  let(:vacation) { create(:vacation, user: user) }
  let(:valid_attributes) { { start_date: Date.today, end_date: Date.today + 5.days, user_id: user.id } }
  let(:invalid_attributes) { { start_date: Date.today - 1.day, end_date: Date.today - 5.days, user_id: user.id } }

  path "/vacations" do
    get "Retrieves all vacations" do
      tags "Vacations"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :start_date, in: :query, type: :string, format: :date
      parameter name: :end_date, in: :query, type: :string, format: :date

      response "200", "vacations found" do
        run_test!
      end
    end

    post "Creates a vacation" do
      tags "Vacations"
      consumes "application/json"
      security [ bearerAuth: [] ]
      parameter name: :vacation, in: :body, schema: {
        type: :object,
        properties: {
          start_date: { type: :string, format: :date },
          end_date: { type: :string, format: :date },
          user_id: { type: :integer }
        },
        required: %w[start_date end_date user_id]
      }

      response "201", "vacation created" do
        let(:vacation) { valid_attributes }
        run_test!
      end

      response "422", "invalid request" do
        let(:vacation) { invalid_attributes }
        run_test!
      end
    end
  end

  path "/vacations/{id}" do
    get "Retrieves a vacation" do
      tags "Vacations"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string

      response "200", "vacation found" do
        let(:id) { vacation.id }
        run_test!
      end

      response "404", "vacation not found" do
        let(:id) { "invalid" }
        run_test!
      end
    end

    patch "Updates a vacation" do
      tags "Vacations"
      consumes "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string
      parameter name: :vacation, in: :body, schema: {
        type: :object,
        properties: {
          start_date: { type: :string, format: :date },
          end_date: { type: :string, format: :date }
        },
        required: %w[start_date end_date]
      }

      response "200", "vacation updated" do
        let(:id) { vacation.id }
        let(:vacation) { { start_date: Date.today + 1.day, end_date: Date.today + 6.days } }
        run_test!
      end

      response "422", "invalid request" do
        let(:id) { vacation.id }
        let(:vacation) { invalid_attributes }
        run_test!
      end
    end

    delete "Deletes a vacation" do
      tags "Vacations"
      parameter name: :id, in: :path, type: :string
      security [ bearerAuth: [] ]
      response "204", "vacation deleted" do
        let(:id) { vacation.id }
        run_test!
      end

      response "404", "vacation not found" do
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
