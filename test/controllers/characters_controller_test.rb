require "test_helper"

class CharactersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @character = characters(:one)
  end

  test "should get index" do
    get characters_url, as: :json
    assert_response :success
  end

  test "should create character" do
    assert_difference("Character.count") do
      post characters_url, params: { character: { character_class_id: @character.character_class_id, max_hp: @character.max_hp, name: @character.name, race_id: @character.race_id, subclass_id: @character.subclass_id, subrace_id: @character.subrace_id, user_id: @character.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show character" do
    get character_url(@character), as: :json
    assert_response :success
  end

  test "should update character" do
    patch character_url(@character), params: { character: { character_class_id: @character.character_class_id, max_hp: @character.max_hp, name: @character.name, race_id: @character.race_id, subclass_id: @character.subclass_id, subrace_id: @character.subrace_id, user_id: @character.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy character" do
    assert_difference("Character.count", -1) do
      delete character_url(@character), as: :json
    end

    assert_response :no_content
  end
end
