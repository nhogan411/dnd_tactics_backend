require "test_helper"

class RacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @race = races(:one)
  end

  test "should get index" do
    get races_url, as: :json
    assert_response :success
  end

  test "should create race" do
    assert_difference("Race.count") do
      post races_url, params: { race: { name: @race.name } }, as: :json
    end

    assert_response :created
  end

  test "should show race" do
    get race_url(@race), as: :json
    assert_response :success
  end

  test "should update race" do
    patch race_url(@race), params: { race: { name: @race.name } }, as: :json
    assert_response :success
  end

  test "should destroy race" do
    assert_difference("Race.count", -1) do
      delete race_url(@race), as: :json
    end

    assert_response :no_content
  end
end
