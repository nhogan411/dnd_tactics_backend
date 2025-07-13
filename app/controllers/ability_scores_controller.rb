class AbilityScoresController < ApplicationController
  before_action :set_ability_score, only: %i[ show update destroy ]

  # GET /ability_scores
  def index
    @ability_scores = AbilityScore.all

    render json: @ability_scores
  end

  # GET /ability_scores/1
  def show
    render json: @ability_score
  end

  # POST /ability_scores
  def create
    @ability_score = AbilityScore.new(ability_score_params)

    if @ability_score.save
      render json: @ability_score, status: :created, location: @ability_score
    else
      render json: @ability_score.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ability_scores/1
  def update
    if @ability_score.update(ability_score_params)
      render json: @ability_score
    else
      render json: @ability_score.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ability_scores/1
  def destroy
    @ability_score.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ability_score
      @ability_score = AbilityScore.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ability_score_params
      params.expect(ability_score: [ :character_id, :score_type, :base_score, :modified_score ])
    end
end
