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
  end
end
