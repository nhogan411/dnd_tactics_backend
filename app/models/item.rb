class Item < ApplicationRecord
  has_many :character_items, dependent: :destroy
  has_many :characters, through: :character_items

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :item_type, presence: true, inclusion: { in: %w[weapon armor shield consumable tool adventuring_gear treasure] }
  validates :rarity, inclusion: { in: %w[common uncommon rare very_rare legendary artifact] }
  validates :damage_type, inclusion: { in: %w[slashing piercing bludgeoning acid cold fire force lightning necrotic poison psychic radiant thunder] }, allow_nil: true
  validates :weapon_type, inclusion: { in: %w[simple martial] }, allow_nil: true
  validates :weapon_category, inclusion: { in: %w[melee ranged] }, allow_nil: true
  validates :armor_type, inclusion: { in: %w[light medium heavy shield] }, allow_nil: true

  # Scopes
  scope :weapons, -> { where(item_type: 'weapon') }
  scope :armor, -> { where(item_type: ['armor', 'shield']) }
  scope :magical, -> { where(is_magical: true) }
  scope :by_rarity, ->(rarity) { where(rarity: rarity) }
  scope :melee_weapons, -> { where(weapon_category: 'melee') }
  scope :ranged_weapons, -> { where(weapon_category: 'ranged') }

  # Methods
  def weapon?
    item_type == 'weapon'
  end

  def armor?
    item_type == 'armor' || item_type == 'shield'
  end

  def magical?
    is_magical
  end

  def total_armor_class
    return nil unless armor?
    armor_class + (magic_bonus || 0)
  end

  def total_damage_bonus
    return nil unless weapon?
    magic_bonus || 0
  end

  def has_property?(property)
    return false unless weapon_properties.present?
    weapon_properties.key?(property) && weapon_properties[property]
  end

  def versatile_damage
    return nil unless has_property?('versatile')
    weapon_properties['versatile']
  end

  def range_increment
    return nil unless ranged_weapons?
    range_normal
  end

  def display_damage
    return nil unless weapon?
    base = damage_dice
    bonus = total_damage_bonus
    bonus > 0 ? "#{base}+#{bonus}" : base
  end

  def display_cost
    return "Priceless" unless cost_gp.present?
    return "#{cost_gp} gp" if cost_gp >= 1

    sp = cost_gp * 10
    return "#{sp} sp" if sp >= 1

    cp = sp * 10
    "#{cp} cp"
  end
end
