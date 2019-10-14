require 'test_helper'

class ApiappControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get apiapp_home_url
    assert_response :success
  end

end
