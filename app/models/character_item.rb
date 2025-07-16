class CharacterItem < ApplicationRecord
  belongs_to :character
  belongs_to :item

  # Equipment state
  def equipped?
    equipped == true
  end

  def unequipped?
    !equipped?
  end

  def can_equip?
    return false if equipped?
    return false unless item.equippable?
    return false if item.requires_attunement? && !character.can_attune_to?(item)

    true
  end

  def equip!
    return false unless can_equip?

    # Handle two-handed weapons
    if item.two_handed_weapon?
      character.character_items.joins(:item)
               .where(equipped: true, items: { weapon_category: 'melee' })
               .update_all(equipped: false)
    end

    # Handle shields with two-handed weapons
    if item.shield? && character.equipped_items.joins(:item).where(items: { weapon_properties: { 'two_handed' => true } }).exists?
      return false
    end

    update!(equipped: true)
    character.attune_to_item(item) if item.requires_attunement?
    true
  end

  def unequip!
    return false unless equipped?

    update!(equipped: false)
    character.unattune_from_item(item) if item.requires_attunement?
    true
  end

  def toggle_equipped!
    equipped? ? unequip! : equip!
  end

  # Quantity and stacking
  def stackable?
    item.stackable?
  end

  def total_weight
    (item.weight_lbs || 0) * (quantity || 1)
  end

  def total_value
    (item.cost_gp || 0) * (quantity || 1)
  end

  def can_stack_with?(other_character_item)
    return false unless stackable?
    return false unless other_character_item.stackable?

    item == other_character_item.item
  end

  def merge_with!(other_character_item)
    return false unless can_stack_with?(other_character_item)

    self.quantity = (quantity || 1) + (other_character_item.quantity || 1)
    save!
    other_character_item.destroy!
    true
  end

  def split!(new_quantity)
    return false if new_quantity >= (quantity || 1)
    return false unless stackable?

    remaining = (quantity || 1) - new_quantity
    self.quantity = remaining
    save!

    character.character_items.create!(
      item: item,
      quantity: new_quantity,
      equipped: false
    )
  end

  # Audit and summary methods
  def audit
    {
      item: item.name,
      quantity: quantity || 1,
      equipped: equipped?,
      weight: total_weight,
      value: total_value,
      stackable: stackable?,
      attunement_required: item.requires_attunement?,
      attuned: character.is_attuned_to?(item)
    }
  end

  def summary_hash
    {
      id: id,
      item_name: item.name,
      quantity: quantity || 1,
      equipped: equipped?,
      weight: total_weight,
      value: item.display_cost
    }
  end
end
