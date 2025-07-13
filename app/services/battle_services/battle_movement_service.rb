module BattleServices
  class BattleMovementService
    def initialize(participant)
      @participant = participant
      @character = participant.character
    end

    def can_move_to?(target_x, target_y)
      return false if target_x < 0 || target_y < 0
      return false if target_x >= @participant.battle.battle_board.width
      return false if target_y >= @participant.battle.battle_board.height

      distance = (target_x - @participant.pos_x).abs + (target_y - @participant.pos_y).abs
      max_squares = @character.movement_speed / 5

      distance <= max_squares
    end

    def move_to!(target_x, target_y)
      raise "Illegal move!" unless can_move_to?(target_x, target_y)

      @participant.update!(pos_x: target_x, pos_y: target_y)
      BattleServices::Logger.log_move(@participant, target_x, target_y)
    end
  end
end
