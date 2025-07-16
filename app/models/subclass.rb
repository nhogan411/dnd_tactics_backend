class Subclass < ApplicationRecord
  belongs_to :character_class
  has_many :characters, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 50 }

  # Scopes
  scope :with_spells, -> { where.not(spells: []) }
  scope :with_proficiencies, -> { where.not(proficiencies: {}) }

  # Methods
  def subclass_feature_at_level(level)
    subclass_features.dig(level.to_s) || {}
  end

  def has_spell?(spell)
    spells.include?(spell)
  end

  def spells_by_level
    return {} if spells.empty?

    spells.group_by { |spell| spell.dig('level') || 0 }
  end

  def cantrips
    spells_by_level[0] || []
  end

  def leveled_spells
    spells_by_level.reject { |level, _| level == 0 }
  end

  def has_proficiency?(type, proficiency)
    proficiencies.dig(type)&.include?(proficiency) || false
  end

  def effective_proficiencies
    base_profs = character_class.weapon_proficiencies + character_class.armor_proficiencies
    subclass_profs = proficiencies || {}

    merged = { 'weapons' => base_profs, 'armor' => base_profs }
    subclass_profs.each do |type, profs|
      merged[type] = (merged[type] || []) + profs
      merged[type].uniq!
    end
    merged
  end

  def display_subclass_type
    case character_class.name
    when 'Barbarian' then 'Primal Path'
    when 'Bard' then 'Bardic College'
    when 'Cleric' then 'Divine Domain'
    when 'Druid' then 'Druid Circle'
    when 'Fighter' then 'Martial Archetype'
    when 'Monk' then 'Monastic Tradition'
    when 'Paladin' then 'Sacred Oath'
    when 'Ranger' then 'Ranger Archetype'
    when 'Rogue' then 'Roguish Archetype'
    when 'Sorcerer' then 'Sorcerous Origin'
    when 'Warlock' then 'Otherworldly Patron'
    when 'Wizard' then 'Arcane Tradition'
    else 'Subclass'
    end
  end

  def available_at_level
    # Most subclasses are available at level 3, but some exceptions exist
    case character_class.name
    when 'Cleric', 'Druid', 'Sorcerer', 'Warlock', 'Wizard' then 1
    when 'Fighter', 'Rogue' then 3
    else 3
    end
  end

  def full_name
    "#{display_subclass_type}: #{name}"
  end

  # Subclass features and abilities
  def features_gained_at_level(level)
    subclass_feature_at_level(level).keys
  end

  def all_features_by_level(character_level)
    features = {}
    (available_at_level..character_level).each do |level|
      level_features = features_gained_at_level(level)
      features[level] = level_features unless level_features.empty?
    end
    features
  end

  def total_features(character_level)
    all_features_by_level(character_level).values.flatten
  end

  def grants_spellcasting?
    spells.any? || subclass_features.values.any? { |features| features.key?('spellcasting') }
  end

  def spellcasting_level
    return nil unless grants_spellcasting?

    # Calculate effective spellcasting level (some subclasses are 1/3 or 1/2 casters)
    case character_class.name
    when 'Paladin', 'Ranger' then 'half'
    when 'Fighter', 'Rogue' then 'third'
    else 'full'
    end
  end

  def spell_slots_at_level(character_level)
    return {} unless grants_spellcasting?

    effective_level = case spellcasting_level
                      when 'half' then (character_level / 2).ceil
                      when 'third' then (character_level / 3).ceil
                      else character_level
                      end

    character_class.spell_slots_at_level(effective_level)
  end

  def unique_proficiencies
    base_profs = character_class.weapon_proficiencies + character_class.armor_proficiencies + character_class.skill_proficiencies.dig('available')
    subclass_profs = proficiencies.values.flatten

    subclass_profs - base_profs
  end

  def expanded_spell_list
    # Some subclasses (like Warlock patrons) have expanded spell lists
    return [] unless spells.any?

    spells.select { |spell| spell.dig('expanded_list') == true }
  end

  def domain_spells
    # For Cleric domains and similar
    expanded_spell_list
  end

  def patron_spells
    # For Warlock patrons
    expanded_spell_list
  end

  def synergy_with_race(race_name)
    # Calculate how well this subclass synergizes with a race
    score = 0

    # This is a simplified example - real implementation would be more complex
    case name.downcase
    when 'draconic bloodline'
      score += 2 if race_name.downcase.include?('dragonborn')
    when 'fiend'
      score += 1 if race_name.downcase.include?('tiefling')
    when 'archfey'
      score += 1 if race_name.downcase.include?('elf')
    end

    score
  end

  def recommended_for_playstyle(playstyle)
    # Simple playstyle recommendations
    case playstyle.downcase
    when 'damage'
      %w[evocation draconic fiend].include?(name.downcase)
    when 'support'
      %w[life enchantment celestial].include?(name.downcase)
    when 'control'
      %w[divination enchantment archfey].include?(name.downcase)
    when 'tank'
      %w[abjuration devotion].include?(name.downcase)
    else
      false
    end
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      character_class: character_class.name,
      subclass_type: display_subclass_type,
      available_at_level: available_at_level,
      grants_spellcasting: grants_spellcasting?,
      spellcasting_level: spellcasting_level,
      spells: spells,
      proficiencies: proficiencies,
      subclass_features: subclass_features,
      unique_proficiencies: unique_proficiencies,
      expanded_spell_list: expanded_spell_list
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      character_class: character_class.name,
      subclass_type: display_subclass_type,
      available_at_level: available_at_level,
      grants_spellcasting: grants_spellcasting?,
      spell_count: spells.count,
      unique_proficiencies: unique_proficiencies.count
    }
  end
end
