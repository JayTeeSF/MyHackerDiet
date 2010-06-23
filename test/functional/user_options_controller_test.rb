require 'test_helper'

class UserOptionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_option" do
    assert_difference('UserOption.count') do
      post :create, :user_option => { }
    end

    assert_redirected_to user_option_path(assigns(:user_option))
  end

  test "should show user_option" do
    get :show, :id => user_options(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_options(:one).to_param
    assert_response :success
  end

  test "should update user_option" do
    put :update, :id => user_options(:one).to_param, :user_option => { }
    assert_redirected_to user_option_path(assigns(:user_option))
  end

  test "should destroy user_option" do
    assert_difference('UserOption.count', -1) do
      delete :destroy, :id => user_options(:one).to_param
    end

    assert_redirected_to user_options_path
  end
end
