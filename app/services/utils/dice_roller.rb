module Utils
  class DiceRoller
    def self.roll(dice_str)
      # Example: "2d6+3", "1d8", "4d4-1"
      match = dice_str.match(/(\d+)d(\d+)([+-]\d+)?/)
      return 0 unless match

      count = match[1].to_i
      die = match[2].to_i
      mod = match[3].to_i

      rolls = count.times.map { rand(1..die) }
      result = rolls.sum + mod

      { result: result, rolls: rolls, modifier: mod }
    end
  end
end
