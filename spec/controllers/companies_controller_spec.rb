require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:valid_attributes) { attributes_for(:company) }
  let(:invalid_attributes) { attributes_for(:company, name: nil) }
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "returns all companies" do
      create_list(:company, 3)
      get :index
      expect(JSON.parse(response.body).size).to eq(4) # Including the user's company
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: company.to_param }
      expect(response).to be_successful
    end

    it "returns the requested company" do
      get :show, params: { id: company.to_param }
      expect(JSON.parse(response.body)["id"]).to eq(company.id)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Company" do
        expect {
          post :create, params: { company: valid_attributes }
        }.to change(Company, :count).by(1)
      end

      it "renders a JSON response with the new company" do
        post :create, params: { company: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        post :create, params: { company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Updated Company Name" } }

      it "updates the requested company" do
        put :update, params: { id: company.to_param, company: new_attributes }
        company.reload
        expect(company.name).to eq("Updated Company Name")
      end

      it "renders a JSON response with the company" do
        put :update, params: { id: company.to_param, company: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        put :update, params: { id: company.to_param, company: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested company" do
      company_to_delete = create(:company)
      expect {
        delete :destroy, params: { id: company_to_delete.to_param }
      }.to change(Company, :count).by(-1)
    end

    it "returns a no content response" do
      delete :destroy, params: { id: company.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
