class Api::V1::ParticipantsController < ApplicationController
  before_action :set_battle
  before_action :set_participant

  # GET /api/v1/battles/:battle_id/participants/:id/abilities
  def abilities
    abilities = @participant.character.character_abilities.includes(:ability)

    render json: abilities.map { |ca|
      ability = ca.ability
      {
        id: ability.id,
        name: ability.name,
        description: ability.description,
        cooldown_turns: ability.cooldown_turns,
        uses_remaining: ca.uses_remaining,
        on_cooldown: cooldown_remaining(ability.name),
        action_type: ability.action_type,
        level_required: ability.level_required
      }
    }
  end

  # POST /api/v1/battles/:battle_id/participants/:id/use_ability
  def use_ability
    ability = Ability.find(params[:ability_id])
    service = AbilityService.new(@participant, ability)

    unless service.usable?
      return render json: { error: "Ability is on cooldown or not usable" }, status: :forbidden
    end

    service.use!
    render json: { success: true, message: "#{ability.name} activated" }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /api/v1/battles/:battle_id/participants/:id/move
  def move
    result = BattleServices::TurnSubmissionService.new(@battle, @participant, {
      action_type: "move",
      target_x: params[:target_x],
      target_y: params[:target_y]
    }).execute!

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /api/v1/battles/:battle_id/participants/:id/attack
  def attack
    result = BattleServices::TurnSubmissionService.new(@battle, @participant, {
      action_type: "attack",
      target_id: params[:target_id]
    }).execute!

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /api/v1/battles/:battle_id/participants/:id/end_turn
  def end_turn
    result = BattleServices::TurnSubmissionService.new(@battle, @participant, {
      action_type: "end_turn"
    }).execute!

    render json: result
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

    def set_battle
      @battle = Battle.find(params[:battle_id])
    end

    def set_participant
      @participant = @battle.battle_participants.find(params[:id])
    end

    def cooldown_remaining(ability_name)
      (@participant.cooldowns || {})[ability_name] || 0
    end
end
