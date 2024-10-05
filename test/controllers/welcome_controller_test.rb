require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get download" do
    get welcome_download_url
    assert_response :success
  end

  test "should get customer" do
    get welcome_customer_url
    assert_response :success
  end

  test "should get permissions" do
    get welcome_permissions_url
    assert_response :success
  end
end
