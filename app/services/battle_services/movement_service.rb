module BattleServices
  class MovementService
    def initialize(participant, target_x, target_y)
      @participant = participant
      @battle = participant.battle
      @target_x = target_x
      @target_y = target_y
      @current_x = participant.pos_x
      @current_y = participant.pos_y
    end

    def valid_move?
      return false unless @target_x && @target_y
      return false unless within_battle_bounds?
      return false unless within_movement_range?
      return false unless square_available?
      return false unless clear_path?

      true
    end

    def execute!
      raise "Invalid move" unless valid_move?

      @participant.update!(
        pos_x: @target_x,
        pos_y: @target_y
      )

      BattleServices::Logger.log_movement(@participant, @current_x, @current_y, @target_x, @target_y)

      {
        success: true,
        participant: @participant,
        from: { x: @current_x, y: @current_y },
        to: { x: @target_x, y: @target_y },
        distance: movement_distance
      }
    end

    private

    def within_battle_bounds?
      @target_x >= 0 && @target_x < @battle.battle_board.width &&
      @target_y >= 0 && @target_y < @battle.battle_board.height
    end

    def within_movement_range?
      movement_distance <= @participant.character.movement_speed
    end

    def movement_distance
      # Calculate Manhattan distance (grid-based movement)
      (@target_x - @current_x).abs + (@target_y - @current_y).abs
    end

    def square_available?
      # Check if target square is occupied by another participant
      occupied = @battle.battle_participants
        .where.not(id: @participant.id)
        .where(pos_x: @target_x, pos_y: @target_y)
        .exists?

      !occupied
    end

    def clear_path?
      # For now, simple implementation - no obstacles
      # Could be enhanced to check terrain and obstacles
      true
    end
  end
end
