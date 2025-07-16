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

  # Equipment management
  def equippable?
    weapon? || armor?
  end

  def requires_attunement?
    attunement_required == true
  end

  def can_be_attuned_by?(character)
    return false unless requires_attunement?
    return false if attunement_requirements.present? && !meets_attunement_requirements?(character)

    true
  end

  def meets_attunement_requirements?(character)
    return true unless attunement_requirements.present?

    attunement_requirements.all? do |req_type, req_value|
      case req_type
      when 'class'
        character.character_class.name.downcase == req_value.downcase
      when 'race'
        character.race.name.downcase == req_value.downcase
      when 'alignment'
        # Would need alignment system
        true
      when 'ability_score'
        character.ability_score(req_value['ability']) >= req_value['minimum']
      else
        true
      end
    end
  end

  def consumable?
    item_type == 'consumable'
  end

  def stackable?
    consumable? || item_type == 'adventuring_gear'
  end

  def has_charges?
    charges.present? && charges > 0
  end

  def single_use?
    consumable? && !has_charges?
  end

  def weight_per_unit
    weight_lbs || 0
  end

  def encumbrance_value(quantity = 1)
    weight_per_unit * quantity
  end

  # Combat and utility
  def finesse_weapon?
    has_property?('finesse')
  end

  def light_weapon?
    has_property?('light')
  end

  def heavy_weapon?
    has_property?('heavy')
  end

  def two_handed_weapon?
    has_property?('two_handed')
  end

  def thrown_weapon?
    has_property?('thrown')
  end

  def ranged_weapon?
    weapon_category == 'ranged'
  end

  def melee_weapon?
    weapon_category == 'melee'
  end

  def shield?
    item_type == 'shield'
  end

  def provides_armor_class?
    armor? && armor_class.present?
  end

  # Display helpers
  def display_properties
    return "None" unless weapon_properties.present?

    props = weapon_properties.select { |_, value| value == true }.keys
    props.map(&:humanize).join(", ")
  end

  def display_weight
    return "Weightless" if weight_lbs.zero?
    weight_lbs == 1 ? "1 lb" : "#{weight_lbs} lbs"
  end

  def display_rarity
    rarity.humanize
  end

  def full_description
    desc = description.to_s
    desc += "\n\nMagical: #{is_magical ? 'Yes' : 'No'}"
    desc += "\nRarity: #{display_rarity}"
    desc += "\nWeight: #{display_weight}"
    desc += "\nCost: #{display_cost}"
    desc += "\nAttunement: #{requires_attunement? ? 'Required' : 'Not required'}" if magical?
    desc += "\nProperties: #{display_properties}" if weapon?
    desc
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      type: item_type,
      subtype: weapon? ? weapon_type : armor_type,
      rarity: rarity,
      magical: magical?,
      cost: cost_gp,
      weight: weight_lbs,
      damage: weapon? ? { dice: damage_dice, type: damage_type } : nil,
      armor_class: armor? ? armor_class : nil,
      properties: weapon_properties,
      attunement: requires_attunement?,
      charges: charges,
      description: description
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      type: item_type,
      rarity: rarity,
      magical: magical?,
      cost: display_cost,
      weight: display_weight,
      damage: display_damage,
      armor_class: total_armor_class,
      attunement: requires_attunement?
    }
  end
end
