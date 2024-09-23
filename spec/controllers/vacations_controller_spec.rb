require 'rails_helper'

RSpec.describe VacationsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { date: Date.today, user_id: user.id } }
  let(:invalid_attributes) { { date: Date.yesterday, user_id: user.id } }

  describe "GET #index" do
    it "returns a success response" do
      Vacation.create! valid_attributes
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      vacation = Vacation.create! valid_attributes
      get :show, params: { id: vacation.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Vacation" do
        expect {
          post :create, params: { vacation: valid_attributes }
        }.to change(Vacation, :count).by(1)
      end

      it "renders a JSON response with the new vacation" do
        post :create, params: { vacation: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new vacation" do
        post :create, params: { vacation: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { date: Date.tomorrow } }

      it "updates the requested vacation" do
        vacation = Vacation.create! valid_attributes
        put :update, params: { id: vacation.to_param, vacation: new_attributes }
        vacation.reload
        expect(vacation.date).to eq(Date.tomorrow)
      end

      it "renders a JSON response with the vacation" do
        vacation = Vacation.create! valid_attributes
        put :update, params: { id: vacation.to_param, vacation: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        vacation = Vacation.create! valid_attributes
        put :update, params: { id: vacation.to_param, vacation: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested vacation" do
      vacation = Vacation.create! valid_attributes
      expect {
        delete :destroy, params: { id: vacation.to_param }
      }.to change(Vacation, :count).by(-1)
    end
  end
end