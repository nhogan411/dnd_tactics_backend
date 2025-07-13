require "test_helper"

class SubracesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subrace = subraces(:one)
  end

  test "should get index" do
    get subraces_url, as: :json
    assert_response :success
  end

  test "should create subrace" do
    assert_difference("Subrace.count") do
      post subraces_url, params: { subrace: { ability_modifiers: @subrace.ability_modifiers, name: @subrace.name, race_id: @subrace.race_id } }, as: :json
    end

    assert_response :created
  end

  test "should show subrace" do
    get subrace_url(@subrace), as: :json
    assert_response :success
  end

  test "should update subrace" do
    patch subrace_url(@subrace), params: { subrace: { ability_modifiers: @subrace.ability_modifiers, name: @subrace.name, race_id: @subrace.race_id } }, as: :json
    assert_response :success
  end

  test "should destroy subrace" do
    assert_difference("Subrace.count", -1) do
      delete subrace_url(@subrace), as: :json
    end

    assert_response :no_content
  end
end
