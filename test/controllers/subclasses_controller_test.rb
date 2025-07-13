require "test_helper"

class SubclassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subclass = subclasses(:one)
  end

  test "should get index" do
    get subclasses_url, as: :json
    assert_response :success
  end

  test "should create subclass" do
    assert_difference("Subclass.count") do
      post subclasses_url, params: { subclass: { bonuses: @subclass.bonuses, character_class_id: @subclass.character_class_id, name: @subclass.name } }, as: :json
    end

    assert_response :created
  end

  test "should show subclass" do
    get subclass_url(@subclass), as: :json
    assert_response :success
  end

  test "should update subclass" do
    patch subclass_url(@subclass), params: { subclass: { bonuses: @subclass.bonuses, character_class_id: @subclass.character_class_id, name: @subclass.name } }, as: :json
    assert_response :success
  end

  test "should destroy subclass" do
    assert_difference("Subclass.count", -1) do
      delete subclass_url(@subclass), as: :json
    end

    assert_response :no_content
  end
end
