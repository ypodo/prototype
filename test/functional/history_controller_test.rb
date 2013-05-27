require 'test_helper'

class HistoryControllerTest < ActionController::TestCase
  test "should get history" do
    get :history
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get export" do
    get :export
    assert_response :success
  end

end
