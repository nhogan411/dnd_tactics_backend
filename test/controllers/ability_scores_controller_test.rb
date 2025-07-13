require "test_helper"

class AbilityScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ability_score = ability_scores(:one)
  end

  test "should get index" do
    get ability_scores_url, as: :json
    assert_response :success
  end

  test "should create ability_score" do
    assert_difference("AbilityScore.count") do
      post ability_scores_url, params: { ability_score: { base_score: @ability_score.base_score, character_id: @ability_score.character_id, modified_score: @ability_score.modified_score, score_type: @ability_score.score_type } }, as: :json
    end

    assert_response :created
  end

  test "should show ability_score" do
    get ability_score_url(@ability_score), as: :json
    assert_response :success
  end

  test "should update ability_score" do
    patch ability_score_url(@ability_score), params: { ability_score: { base_score: @ability_score.base_score, character_id: @ability_score.character_id, modified_score: @ability_score.modified_score, score_type: @ability_score.score_type } }, as: :json
    assert_response :success
  end

  test "should destroy ability_score" do
    assert_difference("AbilityScore.count", -1) do
      delete ability_score_url(@ability_score), as: :json
    end

    assert_response :no_content
  end
end
