class Api::BattlesController < ApplicationController
  before_action :set_battle, only: [:show, :advance_turn, :start]

  # GET /api/battles/:id
  def show
    participants = @battle.battle_participants.includes(character: [:race, :character_class])
    render json: {
      battle: @battle,
      participants: participants.map { |p|
        {
          id: p.id,
          character_name: p.character.name,
          character_class: p.character.character_class.name,
          hp: p.current_hp,
          max_hp: p.character.max_hp,
          pos_x: p.pos_x,
          pos_y: p.pos_y,
          status: p.status,
          team: p.team,
          turn_order: p.turn_order,
          status_effects: p.status_effects || {},
          cooldowns: p.cooldowns || {}
        }
      },
      current_turn_participant_id: @battle.current_participant&.id,
      current_turn_index: @battle.current_turn_index
    }
  end

  # POST /api/battles/:id/start
  def start
    @battle.update!(status: "active")
    render json: { success: true, message: "Battle started." }
  end

  # POST /api/battles/:id/advance_turn
  def advance_turn
    current_index = @battle.current_turn_index || 0
    participant_count = @battle.battle_participants.count
    new_index = (current_index + 1) % participant_count

    @battle.update!(current_turn_index: new_index)
    render json: {
      success: true,
      current_turn_index: new_index,
      current_participant_id: @battle.current_participant&.id
    }
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
  end
end
