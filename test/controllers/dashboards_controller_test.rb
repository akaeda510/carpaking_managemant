require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking_manager = parking_managers(:one)
    sign_in @parking_manager
  end

  test "should get show" do
    get dashboard_url
    assert_response :success
  end
end
