require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  describe "GET #make_reservation" do
    it "returns http success" do
      get :make_reservation
      expect(response).to have_http_status(:success)
    end
  end

end
