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
end
