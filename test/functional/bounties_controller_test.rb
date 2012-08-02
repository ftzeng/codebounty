require 'test_helper'

class BountiesControllerTest < ActionController::TestCase
  setup do
    @bounty = bounties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bounties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bounty" do
    assert_difference('Bounty.count') do
      post :create, bounty: { deadline: @bounty.deadline, description: @bounty.description, problem: @bounty.problem }
    end

    assert_redirected_to bounty_path(assigns(:bounty))
  end

  test "should show bounty" do
    get :show, id: @bounty
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bounty
    assert_response :success
  end

  test "should update bounty" do
    put :update, id: @bounty, bounty: { deadline: @bounty.deadline, description: @bounty.description, problem: @bounty.problem }
    assert_redirected_to bounty_path(assigns(:bounty))
  end

  test "should destroy bounty" do
    assert_difference('Bounty.count', -1) do
      delete :destroy, id: @bounty
    end

    assert_redirected_to bounties_path
  end
end
