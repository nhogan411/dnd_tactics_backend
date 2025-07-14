module BattleServices
  class Logger
    def self.log_attack(actor, target, result_data)
      BattleLog.create!(
        battle: actor.battle,
        actor: actor,
        target: target,
        action_type: "attack",
        result_data: result_data,
        message: "#{actor.character.name} attacks #{target.character.name} for #{result_data[:damage]} damage!"
      )
    end

    def self.log_move(participant, x, y)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant,
        action_type: "move",
        result_data: { to: [ x, y ] },
        message: "#{participant.character.name} moves to (#{x}, #{y})."
      )
    end

    def self.log_knockout(target)
      BattleLog.create!(
        battle: target.battle,
        actor: target,
        action_type: "knockout",
        result_data: {},
        message: "#{target.character.name} is knocked out!"
      )
    end

    def self.log_custom(actor, message)
      BattleLog.create!(
        battle: actor.battle,
        actor: actor,
        action_type: "custom",
        message: message,
        result_data: {}
      )
    end

    def self.log_movement(participant, from_x, from_y, to_x, to_y)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant.character,
        action_type: "movement",
        result_data: {
          from: { x: from_x, y: from_y },
          to: { x: to_x, y: to_y },
          distance: (to_x - from_x).abs + (to_y - from_y).abs
        },
        message: "#{participant.character.name} moves from (#{from_x}, #{from_y}) to (#{to_x}, #{to_y})."
      )
    end

    def self.log_battle_end(battle, winner)
      if winner
        BattleLog.create!(
          battle: battle,
          actor: winner.characters.first,
          action_type: "battle_end",
          result_data: { winner_id: winner.id },
          message: "#{winner.first_name} #{winner.last_name} wins the battle!"
        )
      else
        BattleLog.create!(
          battle: battle,
          actor: nil,
          action_type: "battle_end",
          result_data: { winner_id: nil },
          message: "Battle ends with no survivors!"
        )
      end
    end

    def self.log_turn_start(battle, participant)
      BattleLog.create!(
        battle: battle,
        actor: participant.character,
        action_type: "turn_start",
        result_data: { turn_order: participant.turn_order },
        message: "#{participant.character.name}'s turn begins."
      )
    end

    def self.log_initiative_reroll(battle)
      BattleLog.create!(
        battle: battle,
        actor: nil,
        action_type: "initiative_reroll",
        result_data: {},
        message: "Initiative order has been re-rolled."
      )
    end

    def self.log_defeat(participant)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant.character,
        action_type: "defeat",
        result_data: {},
        message: "#{participant.character.name} has been defeated!"
      )
    end

    def self.log_status_effect(participant, effect_name, duration)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant.character,
        action_type: "status_effect",
        result_data: { effect: effect_name, duration: duration },
        message: "#{participant.character.name} gains #{effect_name} for #{duration} turns."
      )
    end

    def self.log_status_effect_removed(participant, effect_name)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant.character,
        action_type: "status_effect_removed",
        result_data: { effect: effect_name },
        message: "#{participant.character.name}'s #{effect_name} effect ends."
      )
    end

    def self.log_healing(participant, amount)
      BattleLog.create!(
        battle: participant.battle,
        actor: participant.character,
        action_type: "healing",
        result_data: { amount: amount },
        message: "#{participant.character.name} heals for #{amount} HP."
      )
    end
  end
end
