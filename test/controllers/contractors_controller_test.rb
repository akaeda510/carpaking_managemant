require "test_helper"

class ContractorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parking_manager = parking_managers(:manager_one)
    sign_in @parking_manager
  end

  test "should get new" do
    get contractors_new_url
    assert_response :success
  end
end
