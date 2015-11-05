require 'test_helper'

class Forum::RootControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get index for guest" do
    get :index
    assert_response :success
    assert_template 'application'
    #assert_not_nil assigns(:v_forum_articles)
  end
  
  test "should get index for user" do
    sign_in users(:udin)
    get :index
    assert_response :success
    assert_template 'application'
    #assert_not_nil assigns(:v_forum_articles)
  end
  
  test "should get search for guest" do
    get :search, q: "bertanya"
    assert_response :success
    assert_template 'application'
    #assert_not_nil assigns(:v_forum_articles)
  end
  
  test "should get search for user" do
    sign_in users(:udin)
    get :search, q: "bertanya"
    assert_response :success
    assert_template 'application'
    #assert_not_nil assigns(:v_forum_articles)
  end
  
  test "should get per_category for guest" do
    get :per_category, forum_cat_slug: "ruby"
    assert_response :success
    assert_template 'application'
    #assert_not_nil assigns(:v_forum_articles)
  end
end
