require 'test_helper'

class MoviePlaylistTypesControllerTest < ActionController::TestCase
  setup do
    @movie_playlist_type = movie_playlist_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_playlist_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie_playlist_type" do
    assert_difference('MoviePlaylistType.count') do
      post :create, movie_playlist_type: { name: @movie_playlist_type.name }
    end

    assert_redirected_to movie_playlist_type_path(assigns(:movie_playlist_type))
  end

  test "should show movie_playlist_type" do
    get :show, id: @movie_playlist_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie_playlist_type
    assert_response :success
  end

  test "should update movie_playlist_type" do
    put :update, id: @movie_playlist_type, movie_playlist_type: { name: @movie_playlist_type.name }
    assert_redirected_to movie_playlist_type_path(assigns(:movie_playlist_type))
  end

  test "should destroy movie_playlist_type" do
    assert_difference('MoviePlaylistType.count', -1) do
      delete :destroy, id: @movie_playlist_type
    end

    assert_redirected_to movie_playlist_types_path
  end
end
