require "test_helper"

class GridControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grid_index_url
    assert_response :success
  end

  test "should get new" do
    get grid_new_url
    assert_response :success
  end

  test "should get create" do
    get grid_create_url
    assert_response :success
  end
end
