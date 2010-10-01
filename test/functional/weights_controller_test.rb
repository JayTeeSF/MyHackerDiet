require 'test_helper'

class WeightsControllerTest < ActionController::TestCase
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
    assert_not_nil assigns(:weights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weight" do
    assert_difference('Weight.count') do
      post :create, :weight => {:user_id => 100, :rec_date => '2010-01-01', :weight => 100 }
    end

    assert_redirected_to weights_path
  end

  test "should show weight" do
    get :show, :id => weights(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => weights(:one).to_param
    assert_response :success
  end

  test "should update weight" do
    put :update, :id => weights(:one).to_param, :weight => { }
    assert_redirected_to weights_path
  end

  test "should destroy weight" do
    assert_difference('Weight.count', -1) do
      delete :destroy, :id => weights(:one).to_param
    end

    assert_redirected_to weights_path
  end
end
