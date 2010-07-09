require 'test_helper'

class StepsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    sign_in :user, @jon

    get :index
    assert_response :success
    assert_not_nil assigns(:steps)
  end

  test "should get new" do
    sign_in :user, @jon

    get :new
    assert_response :success
  end

  test "should create step" do
    sign_in :user, @jon

    assert_difference('Step.count') do
      post :create, :step => { }
    end

    assert_redirected_to steps_path
  end

  test "should show step" do
    sign_in :user, @jon

    get :show, :id => steps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    sign_in :user, @jon

    get :edit, :id => steps(:one).to_param
    assert_response :success
  end

  test "should update step" do
    sign_in :user, @jon

    put :update, :id => steps(:one).to_param, :step => { }
    assert_redirected_to steps_path
  end

  test "should destroy step" do
    sign_in :user, @jon

    assert_difference('Step.count', -1) do
      delete :destroy, :id => steps(:one).to_param
    end

    assert_redirected_to steps_path
  end
end
