class AbilityService
  def initialize(participant, ability)
    @participant = participant
    @character = participant.character
    @ability = ability
    @battle = participant.battle
  end

  def usable?
    @character.level >= @ability.level_required &&
      (@ability.action_type != "active" || ability_ready?)
  end

  def use!
    raise "Ability not usable" unless usable?

    case @ability.name
    when "Rage"
      activate_rage
    when "Sneak Attack"
      # handled in CombatService automatically
    else
      raise "Ability not implemented"
    end
  end

  private

    def ability_ready?
      char_ability = CharacterAbility.find_by(character: @character, ability: @ability)
      char_ability&.uses_remaining.to_i > 0
    end

    def activate_rage
      @participant.update!(status_effects: { raging: 3 }) # 3 turns
      log("rages with fury!")
      use_charge!
    end

    def use_charge!
      ca = CharacterAbility.find_by(character: @character, ability: @ability)
      return unless ca
      ca.decrement!(:uses_remaining)
    end

    def log(msg)
      BattleServices::Logger.log_custom(@participant, "#{@character.name} #{msg}")
    end
end
