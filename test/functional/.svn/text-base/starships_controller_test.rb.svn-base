require 'test_helper'

class StarshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:starships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create starship" do
    assert_difference('Starship.count') do
      post :create, :starship => { }
    end

    assert_redirected_to starship_path(assigns(:starship))
  end

  test "should show starship" do
    get :show, :id => starships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => starships(:one).to_param
    assert_response :success
  end

  test "should update starship" do
    put :update, :id => starships(:one).to_param, :starship => { }
    assert_redirected_to starship_path(assigns(:starship))
  end

  test "should destroy starship" do
    assert_difference('Starship.count', -1) do
      delete :destroy, :id => starships(:one).to_param
    end

    assert_redirected_to starships_path
  end
end
