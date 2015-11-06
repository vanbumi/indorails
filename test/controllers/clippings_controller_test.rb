require 'test_helper'

class ClippingsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get index for guest" do
    get :index
    assert_response :success
    assert_template 'application'
    assert_not_nil Clipping.all
  end
end
