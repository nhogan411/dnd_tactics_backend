require "test_helper"

class CharacterClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @character_class = character_classes(:one)
  end

  test "should get index" do
    get character_classes_url, as: :json
    assert_response :success
  end

  test "should create character_class" do
    assert_difference("CharacterClass.count") do
      post character_classes_url, params: { character_class: { ability_requirements: @character_class.ability_requirements, bonuses: @character_class.bonuses, name: @character_class.name } }, as: :json
    end

    assert_response :created
  end

  test "should show character_class" do
    get character_class_url(@character_class), as: :json
    assert_response :success
  end

  test "should update character_class" do
    patch character_class_url(@character_class), params: { character_class: { ability_requirements: @character_class.ability_requirements, bonuses: @character_class.bonuses, name: @character_class.name } }, as: :json
    assert_response :success
  end

  test "should destroy character_class" do
    assert_difference("CharacterClass.count", -1) do
      delete character_class_url(@character_class), as: :json
    end

    assert_response :no_content
  end
end
