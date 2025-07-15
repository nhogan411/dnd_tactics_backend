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
end
