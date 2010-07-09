require 'test_helper'

class WeightsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    sign_in :user, @jon

    get :index
    assert_response :success
    assert_not_nil assigns(:weights)
  end

  test "should get new" do
    sign_in :user, @jon
    get :new
    assert_response :success
  end

  test "should create weight" do
    sign_in :user, @jon
    assert_difference('Weight.count') do
      post :create, :weight => { }
    end

    assert_redirected_to weights_path
  end

  test "should show weight" do
    sign_in :user, @jon
    get :show, :id => weights(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    sign_in :user, @jon
    get :edit, :id => weights(:one).to_param
    assert_response :success
  end

  test "should update weight" do
    sign_in :user, @jon
    put :update, :id => weights(:one).to_param, :weight => { }
    assert_redirected_to weights_path
  end

  test "should destroy weight" do
    sign_in :user, @jon
    assert_difference('Weight.count', -1) do
      delete :destroy, :id => weights(:one).to_param
    end

    assert_redirected_to weights_path
  end
end
