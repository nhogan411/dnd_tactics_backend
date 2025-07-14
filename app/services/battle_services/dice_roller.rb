module BattleServices
  class DiceRoller
    # Standard D&D dice rolls
    def self.roll(sides, count = 1, modifier = 0)
      total = 0
      rolls = []

      count.times do
        roll = rand(1..sides)
        rolls << roll
        total += roll
      end

      total += modifier

      {
        total: total,
        rolls: rolls,
        modifier: modifier,
        formula: generate_formula(count, sides, modifier)
      }
    end

    # Common D&D rolls
    def self.d4(count = 1, modifier = 0)
      roll(4, count, modifier)
    end

    def self.d6(count = 1, modifier = 0)
      roll(6, count, modifier)
    end

    def self.d8(count = 1, modifier = 0)
      roll(8, count, modifier)
    end

    def self.d10(count = 1, modifier = 0)
      roll(10, count, modifier)
    end

    def self.d12(count = 1, modifier = 0)
      roll(12, count, modifier)
    end

    def self.d20(count = 1, modifier = 0)
      roll(20, count, modifier)
    end

    def self.d100(count = 1, modifier = 0)
      roll(100, count, modifier)
    end

    # Advantage/Disadvantage for d20 rolls
    def self.d20_advantage(modifier = 0)
      roll1 = roll(20, 1, 0)
      roll2 = roll(20, 1, 0)
      best_roll = [roll1[:total], roll2[:total]].max

      {
        total: best_roll + modifier,
        rolls: [roll1[:rolls][0], roll2[:rolls][0]],
        modifier: modifier,
        formula: "d20 (advantage)#{modifier >= 0 ? '+' : ''}#{modifier != 0 ? modifier : ''}".gsub(/\+0$/, ''),
        advantage: true,
        best_roll: best_roll
      }
    end

    def self.d20_disadvantage(modifier = 0)
      roll1 = roll(20, 1, 0)
      roll2 = roll(20, 1, 0)
      worst_roll = [roll1[:total], roll2[:total]].min

      {
        total: worst_roll + modifier,
        rolls: [roll1[:rolls][0], roll2[:rolls][0]],
        modifier: modifier,
        formula: "d20 (disadvantage)#{modifier >= 0 ? '+' : ''}#{modifier != 0 ? modifier : ''}".gsub(/\+0$/, ''),
        disadvantage: true,
        worst_roll: worst_roll
      }
    end

    # Parse dice notation like "2d6+3" or "1d20+5"
    def self.parse_and_roll(dice_string)
      # Match patterns like "2d6+3", "1d20-2", "d4", etc.
      match = dice_string.match(/(\d*)d(\d+)([+-]\d+)?/)
      return { error: "Invalid dice notation" } unless match

      count = match[1].empty? ? 1 : match[1].to_i
      sides = match[2].to_i
      modifier = match[3] ? match[3].to_i : 0

      roll(sides, count, modifier)
    end

  private

    def self.generate_formula(count, sides, modifier)
      base = "#{count}d#{sides}"
      return base if modifier == 0
      return "#{base}#{modifier}" if modifier < 0
      "#{base}+#{modifier}"
    end
  end
end
