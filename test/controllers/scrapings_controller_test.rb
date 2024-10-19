require "test_helper"

class ScrapingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get scrapings_create_url
    assert_response :success
  end

  test "should get show" do
    get scrapings_show_url
    assert_response :success
  end

  test "should get update" do
    get scrapings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get scrapings_destroy_url
    assert_response :success
  end
end
