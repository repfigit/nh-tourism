require 'rails_helper'

RSpec.describe "Admin::Destinations", type: :request do
  before { admin_sign_in_as(create(:administrator)) }

  describe "GET /admin/destinations" do
    it "returns http success" do
      get admin_destinations_path
      expect(response).to be_success_with_view_check('index')
    end
  end

end
