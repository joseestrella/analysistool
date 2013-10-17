require 'test_helper'

class GpsejemplosControllerTest < ActionController::TestCase
  setup do
    @gpsejemplo = gpsejemplos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gpsejemplos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gpsejemplo" do
    assert_difference('Gpsejemplo.count') do
      post :create, gpsejemplo: { idUsuario: @gpsejemplo.idUsuario, latitude: @gpsejemplo.latitude, longitude: @gpsejemplo.longitude, timestamp: @gpsejemplo.timestamp }
    end

    assert_redirected_to gpsejemplo_path(assigns(:gpsejemplo))
  end

  test "should show gpsejemplo" do
    get :show, id: @gpsejemplo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gpsejemplo
    assert_response :success
  end

  test "should update gpsejemplo" do
    put :update, id: @gpsejemplo, gpsejemplo: { idUsuario: @gpsejemplo.idUsuario, latitude: @gpsejemplo.latitude, longitude: @gpsejemplo.longitude, timestamp: @gpsejemplo.timestamp }
    assert_redirected_to gpsejemplo_path(assigns(:gpsejemplo))
  end

  test "should destroy gpsejemplo" do
    assert_difference('Gpsejemplo.count', -1) do
      delete :destroy, id: @gpsejemplo
    end

    assert_redirected_to gpsejemplos_path
  end
end
