class Api::BattlesController < ApplicationController
  before_action :set_battle

  # GET /api/battles/:id
  def show
    participants = @battle.battle_participants.includes(character: :character_class)
    render json: {
      battle: @battle,
      participants: participants.map { |p|
        {
          id: p.id,
          character_name: p.character.name,
          hp: p.current_hp,
          max_hp: p.max_hp,
          pos_x: p.pos_x,
          pos_y: p.pos_y,
          status_effects: p.status_effects || {},
          cooldowns: p.cooldowns || {}
        }
      },
      current_turn_participant_id: @battle.battle_participants.order(:turn_order)[@battle.current_turn_index % @battle.battle_participants.count]&.id
    }
  end

  # POST /api/battles/:id/advance_turn
  def advance_turn
    service = Battle::TurnService.new(@battle)
    service.end_turn
    render json: { success: true, current_turn_index: @battle.current_turn_index }
  end

  private

    def set_battle
      @battle = Battle.find(params[:id])
    end

    def start
      authorize @battle, :start?

      @battle.update!(status: "active")
      Battle::Initializer.new(@battle).call
      render json: { success: true, message: "Battle started." }
    end
end
