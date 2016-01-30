require 'test_helper'

class CelestialBodiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:celestial_bodies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create celestial_body" do
    assert_difference('CelestialBody.count') do
      post :create, :celestial_body => { }
    end

    assert_redirected_to celestial_body_path(assigns(:celestial_body))
  end

  test "should show celestial_body" do
    get :show, :id => celestial_bodies(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => celestial_bodies(:one).to_param
    assert_response :success
  end

  test "should update celestial_body" do
    put :update, :id => celestial_bodies(:one).to_param, :celestial_body => { }
    assert_redirected_to celestial_body_path(assigns(:celestial_body))
  end

  test "should destroy celestial_body" do
    assert_difference('CelestialBody.count', -1) do
      delete :destroy, :id => celestial_bodies(:one).to_param
    end

    assert_redirected_to celestial_bodies_path
  end
end
