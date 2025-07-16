class CharacterSpell < ApplicationRecord
  belongs_to :character
  belongs_to :spell

  validates :character_id, uniqueness: { scope: :spell_id }
  validates :source, inclusion: { in: %w[class race feat magic_item background] }
  validates :level_gained, numericality: { greater_than: 0, less_than_or_equal_to: 20 }

  scope :prepared, -> { where(prepared: true) }
  scope :known, -> { where(known: true) }
  scope :by_source, ->(source) { where(source: source) }
  scope :cantrips, -> { joins(:spell).where(spells: { level: 0 }) }
  scope :by_level, ->(level) { joins(:spell).where(spells: { level: level }) }

  def spell_level
    spell.level
  end

  def cantrip?
    spell.cantrip?
  end

  def from_class?
    source == 'class'
  end

  def from_race?
    source == 'race'
  end

  def from_feat?
    source == 'feat'
  end

  def from_magic_item?
    source == 'magic_item'
  end

  def from_background?
    source == 'background'
  end

  # Spell management
  def can_be_prepared?
    return false if cantrip? # Cantrips don't need preparation
    return false unless known?
    return false if prepared?
    return false unless character.prepared_caster?

    character.can_prepare_more_spells?
  end

  def can_be_unprepared?
    return false unless prepared?
    return false if cantrip? # Cantrips are always prepared

    true
  end

  def prepare!
    return false unless can_be_prepared?

    update!(prepared: true)
  end

  def unprepare!
    return false unless can_be_unprepared?

    update!(prepared: false)
  end

  def toggle_prepared!
    prepared? ? unprepare! : prepare!
  end

  def can_be_cast?
    return false unless known?
    return false if !prepared? && character.prepared_caster? && !cantrip?

    character.can_cast_spell?(spell)
  end

  def cast!(slot_level = nil)
    return false unless can_be_cast?

    character.cast_spell(spell, slot_level)
  end

  def learned_at_level
    level_gained
  end

  def spell_school
    spell.school
  end

  def spell_name
    spell.name
  end

  def spell_description
    spell.description
  end

  def always_prepared?
    cantrip? || from_race? || from_feat? || from_magic_item?
  end

  def removable?
    # Generally spells from class can be replaced on level up
    from_class? && !cantrip?
  end

  def source_description
    case source
    when 'class' then "#{character.character_class.name} spell"
    when 'race' then "#{character.race.name} racial spell"
    when 'feat' then "Feat spell"
    when 'magic_item' then "Magic item spell"
    when 'background' then "Background spell"
    else source.humanize
    end
  end

  def display_preparation_status
    return "Always prepared" if always_prepared?
    return "Prepared" if prepared?
    return "Known" if known?
    "Unknown"
  end

  # Audit and summary methods
  def audit
    {
      spell: spell.name,
      level: spell_level,
      school: spell_school,
      source: source,
      source_description: source_description,
      level_gained: level_gained,
      known: known?,
      prepared: prepared?,
      always_prepared: always_prepared?,
      can_be_cast: can_be_cast?,
      removable: removable?
    }
  end

  def summary_hash
    {
      id: id,
      spell_name: spell.name,
      level: spell_level,
      school: spell_school,
      source: source_description,
      preparation_status: display_preparation_status,
      can_cast: can_be_cast?
    }
  end
end
