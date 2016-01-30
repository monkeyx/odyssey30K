require 'test_helper'

class ColoniesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:colonies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create colony" do
    assert_difference('Colony.count') do
      post :create, :colony => { }
    end

    assert_redirected_to colony_path(assigns(:colony))
  end

  test "should show colony" do
    get :show, :id => colonies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => colonies(:one).to_param
    assert_response :success
  end

  test "should update colony" do
    put :update, :id => colonies(:one).to_param, :colony => { }
    assert_redirected_to colony_path(assigns(:colony))
  end

  test "should destroy colony" do
    assert_difference('Colony.count', -1) do
      delete :destroy, :id => colonies(:one).to_param
    end

    assert_redirected_to colonies_path
  end
end
