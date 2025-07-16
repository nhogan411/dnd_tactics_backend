class User < ApplicationRecord
  has_many :characters, dependent: :destroy
  has_many :battle_participants, dependent: :destroy
  has_many :battle_participant_selections, dependent: :destroy
  has_many :battles_as_player_1, class_name: "Battle", foreign_key: "user_1_id", dependent: :destroy
  has_many :battles_as_player_2, class_name: "Battle", foreign_key: "user_2_id", dependent: :destroy
  has_many :won_battles, class_name: "Battle", foreign_key: "winner_id", dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  # Optional: convenience method for all battles
  def battles
    Battle.where("user_1_id = ? OR user_2_id = ?", id, id)
  end

  # User management
  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    full_name
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end

  # Character management
  def active_characters
    characters.where(current_hp: 1..)
  end

  def dead_characters
    characters.where(current_hp: 0)
  end

  def characters_by_level
    characters.group(:level).count
  end

  def characters_by_class
    characters.joins(:character_class).group('character_classes.name').count
  end

  def characters_by_race
    characters.joins(:race).group('races.name').count
  end

  def highest_level_character
    characters.maximum(:level) || 0
  end

  def total_character_levels
    characters.sum(:level)
  end

  def spellcasting_characters
    characters.where.not(spellcasting_ability: nil)
  end

  # Battle statistics
  def active_battles
    battles.where(status: 'active')
  end

  def finished_battles
    battles.where(status: 'finished')
  end

  def battle_win_rate
    return 0 if finished_battles.empty?

    won_battles.count.to_f / finished_battles.count
  end

  def battles_won
    won_battles.count
  end

  def battles_lost
    finished_battles.count - battles_won
  end

  def total_battles
    battles.count
  end

  def currently_in_battle?
    active_battles.exists?
  end

  def battle_statistics
    {
      total: total_battles,
      won: battles_won,
      lost: battles_lost,
      win_rate: (battle_win_rate * 100).round(1),
      active: active_battles.count
    }
  end

  # Character creation helpers
  def can_create_character?
    # Add any limits or restrictions here
    true
  end

  def next_character_name_suggestion
    base_name = first_name
    existing_names = characters.pluck(:name)

    return base_name unless existing_names.include?(base_name)

    counter = 2
    while existing_names.include?("#{base_name} #{counter}")
      counter += 1
    end

    "#{base_name} #{counter}"
  end

  def favorite_character_class
    characters_by_class.max_by { |_, count| count }&.first
  end

  def favorite_character_race
    characters_by_race.max_by { |_, count| count }&.first
  end

  # Audit and summary methods
  def audit
    {
      id: id,
      name: full_name,
      email: email,
      characters: {
        total: characters.count,
        active: active_characters.count,
        dead: dead_characters.count,
        highest_level: highest_level_character,
        total_levels: total_character_levels,
        by_class: characters_by_class,
        by_race: characters_by_race,
        spellcasters: spellcasting_characters.count
      },
      battles: battle_statistics,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  def summary_hash
    {
      id: id,
      name: full_name,
      email: email,
      characters: characters.count,
      battles: total_battles,
      win_rate: "#{(battle_win_rate * 100).round(1)}%"
    }
  end
end
