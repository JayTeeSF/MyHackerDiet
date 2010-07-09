require 'test_helper'

class StepsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in :user, @jon
  end

  def teardown
    sign_out @jon
  end


  test "should get index" do

    get :index
    assert_response :success
    assert_not_nil assigns(:steps)
  end

  test "should get new" do

    get :new
    assert_response :success
  end

  test "should create step" do

    assert_difference('Step.count') do
      post :create, :step => { }
    end

    assert_redirected_to steps_path
  end

  test "should show step" do

    get :show, :id => steps(:one).to_param
    assert_response :success
  end

  test "should get edit" do

    get :edit, :id => steps(:one).to_param
    assert_response :success
  end

  test "should update step" do

    put :update, :id => steps(:one).to_param, :step => { }
    assert_redirected_to steps_path
  end

  test "should destroy step" do

    assert_difference('Step.count', -1) do
      delete :destroy, :id => steps(:one).to_param
    end

    assert_redirected_to steps_path
  end
end
