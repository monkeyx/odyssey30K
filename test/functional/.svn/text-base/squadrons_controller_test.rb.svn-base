require 'test_helper'

class SquadronsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:squadrons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create squadron" do
    assert_difference('Squadron.count') do
      post :create, :squadron => { }
    end

    assert_redirected_to squadron_path(assigns(:squadron))
  end

  test "should show squadron" do
    get :show, :id => squadrons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => squadrons(:one).to_param
    assert_response :success
  end

  test "should update squadron" do
    put :update, :id => squadrons(:one).to_param, :squadron => { }
    assert_redirected_to squadron_path(assigns(:squadron))
  end

  test "should destroy squadron" do
    assert_difference('Squadron.count', -1) do
      delete :destroy, :id => squadrons(:one).to_param
    end

    assert_redirected_to squadrons_path
  end
end
