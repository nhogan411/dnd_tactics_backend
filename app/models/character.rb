class Character < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :subrace
  belongs_to :character_class
  belongs_to :subclass
  belongs_to :background, optional: true

  has_many :ability_scores, dependent: :destroy
  has_many :character_items, dependent: :destroy
  has_many :items, through: :character_items
  has_many :character_abilities, dependent: :destroy
  has_many :abilities, through: :character_abilities
  has_many :character_feats, dependent: :destroy
  has_many :feats, through: :character_feats
  has_many :character_spells, dependent: :destroy
  has_many :spells, through: :character_spells
  has_many :battle_participants, dependent: :destroy
  has_many :battle_participant_selections, dependent: :destroy
  has_many :character_class_levels, dependent: :destroy
  has_many :battle_logs_as_actor, class_name: "BattleLog", foreign_key: "actor_id", dependent: :destroy
  has_many :battle_logs_as_target, class_name: "BattleLog", foreign_key: "target_id", dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :level, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validates :movement_speed, numericality: { only_integer: true, greater_than: 0 }
  validates :max_hp, numericality: { only_integer: true, greater_than: 0 }
  validates :current_hp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :visibility_range, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :armor_class, numericality: { only_integer: true, greater_than: 0 }
  validates :experience_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :by_level, ->(level) { where(level: level) }
  scope :by_class, ->(class_name) { joins(:character_class).where(character_classes: { name: class_name }) }
  scope :by_race, ->(race_name) { joins(:race).where(races: { name: race_name }) }
  scope :spellcasters, -> { where.not(spellcasting_ability: nil) }
  scope :with_condition, ->(condition) { where("conditions ? :condition", condition: condition) }

  # Callbacks
  before_validation :calculate_derived_stats
  after_update :check_level_up

  # Helper methods to get specific ability scores
  def strength
    ability_scores.find_by(score_type: "STR")&.modified_score || 10
  end

  def dexterity
    ability_scores.find_by(score_type: "DEX")&.modified_score || 10
  end

  def constitution
    ability_scores.find_by(score_type: "CON")&.modified_score || 10
  end

  def intelligence
    ability_scores.find_by(score_type: "INT")&.modified_score || 10
  end

  def wisdom
    ability_scores.find_by(score_type: "WIS")&.modified_score || 10
  end

  def charisma
    ability_scores.find_by(score_type: "CHA")&.modified_score || 10
  end

  def ability_score(ability)
    case ability.upcase
    when "STR", "STRENGTH" then strength
    when "DEX", "DEXTERITY" then dexterity
    when "CON", "CONSTITUTION" then constitution
    when "INT", "INTELLIGENCE" then intelligence
    when "WIS", "WISDOM" then wisdom
    when "CHA", "CHARISMA" then charisma
    else 10
    end
  end

  # Helper method to get ability modifier (for D&D mechanics)
  def ability_modifier(score)
    (score - 10) / 2
  end

  # Convenience methods for ability modifiers (using modified_score)
  def strength_modifier
    ability_modifier(strength)
  end

  def dexterity_modifier
    ability_modifier(dexterity)
  end

  def constitution_modifier
    ability_modifier(constitution)
  end

  def intelligence_modifier
    ability_modifier(intelligence)
  end

  def wisdom_modifier
    ability_modifier(wisdom)
  end

  def charisma_modifier
    ability_modifier(charisma)
  end

  # PROFICIENCY SYSTEM
  def calculate_proficiency_bonus
    case level
    when 1..4 then 2
    when 5..8 then 3
    when 9..12 then 4
    when 13..16 then 5
    when 17..20 then 6
    else 2
    end
  end

  def has_proficiency?(type, proficiency)
    case type
    when 'skill'
      skill_proficiencies.include?(proficiency)
    when 'weapon'
      weapon_proficiencies.include?(proficiency)
    when 'armor'
      armor_proficiencies.include?(proficiency)
    when 'tool'
      tool_proficiencies.include?(proficiency)
    when 'language'
      language_proficiencies.include?(proficiency)
    else
      false
    end
  end

  def has_expertise?(skill)
    skill_expertise.include?(skill)
  end

  def skill_modifier(skill)
    ability_mod = case skill.downcase
    when 'acrobatics', 'sleight_of_hand', 'stealth' then dexterity_modifier
    when 'animal_handling', 'insight', 'medicine', 'perception', 'survival' then wisdom_modifier
    when 'arcana', 'history', 'investigation', 'nature', 'religion' then intelligence_modifier
    when 'athletics' then strength_modifier
    when 'deception', 'intimidation', 'performance', 'persuasion' then charisma_modifier
    else 0
    end

    bonus = ability_mod
    bonus += proficiency_bonus if has_proficiency?('skill', skill)
    bonus += proficiency_bonus if has_expertise?(skill) # Expertise adds proficiency bonus again
    bonus
  end

  def add_proficiency(type, proficiency)
    case type
    when 'skill'
      self.skill_proficiencies = (skill_proficiencies + [proficiency]).uniq
    when 'weapon'
      self.weapon_proficiencies = (weapon_proficiencies + [proficiency]).uniq
    when 'armor'
      self.armor_proficiencies = (armor_proficiencies + [proficiency]).uniq
    when 'tool'
      self.tool_proficiencies = (tool_proficiencies + [proficiency]).uniq
    when 'language'
      self.language_proficiencies = (language_proficiencies + [proficiency]).uniq
    end
    save
  end

  def add_expertise(skill)
    return false unless has_proficiency?('skill', skill)

    self.skill_expertise = (skill_expertise + [skill]).uniq
    save
  end

  # HEALTH & COMBAT STATS
  def calculate_max_hp
    base_hp = character_class.hit_die
    con_modifier = constitution_modifier
    level_hp = base_hp + ((level - 1) * (character_class.hit_die / 2 + 1 + con_modifier))
    level_hp + con_modifier # First level gets max hit die + con mod
  end

  def calculate_armor_class
    base_ac = 10 + dexterity_modifier

    # Add armor AC if wearing armor
    equipped_armor = character_items.joins(:item).where(equipped: true, items: { item_type: ['armor', 'shield'] })
    equipped_armor.each do |char_item|
      item = char_item.item
      if item.armor_type == 'shield'
        base_ac += item.armor_class
      else
        # Replace base AC with armor AC
        armor_ac = item.armor_class
        armor_ac += [dexterity_modifier, item.max_dex_bonus || 99].min
        base_ac = armor_ac
      end
    end

    base_ac
  end

  def calculate_initiative
    dexterity_modifier + initiative_modifier
  end

  def is_alive?
    current_hp > 0
  end

  def is_unconscious?
    current_hp <= 0
  end

  def is_stable?
    is_unconscious? && death_save_successes >= 3
  end

  def is_dying?
    is_unconscious? && death_save_failures < 3 && death_save_successes < 3
  end

  def is_dead?
    death_save_failures >= 3 || current_hp <= -(constitution_modifier.abs)
  end

  def heal(amount)
    if is_unconscious?
      reset_death_saves
    end

    self.current_hp = [current_hp + amount, max_hp].min
    save
  end

  def take_damage(amount)
    # Apply temporary HP first
    if temporary_hp > 0
      temp_damage = [amount, temporary_hp].min
      self.temporary_hp -= temp_damage
      amount -= temp_damage
    end

    # Apply remaining damage to current HP
    if amount > 0
      self.current_hp = [current_hp - amount, 0].max

      # Check for instant death
      if current_hp == 0 && amount >= max_hp
        self.death_save_failures = 3
      end
    end

    save
  end

  def grant_temporary_hp(amount)
    self.temporary_hp = [temporary_hp, amount].max # Temp HP doesn't stack
    save
  end

  def total_hp
    current_hp + temporary_hp
  end

  def make_death_save(roll)
    return false unless is_dying?

    if roll >= 10
      self.death_save_successes += 1
      if death_save_successes >= 3
        self.current_hp = 1
        reset_death_saves
      end
    else
      self.death_save_failures += 1
      if roll == 1
        self.death_save_failures += 1 # Natural 1 counts as two failures
      end
    end

    save
  end

  def reset_death_saves
    self.death_save_successes = 0
    self.death_save_failures = 0
    save
  end

  def hit_dice_available
    character_class.hit_die
  end

  def hit_dice_used_for_class
    hit_dice_used.dig(character_class.name.downcase) || 0
  end

  def hit_dice_remaining
    level - hit_dice_used_for_class
  end

  def can_spend_hit_dice?
    hit_dice_remaining > 0
  end

  def spend_hit_dice(count = 1)
    return false unless can_spend_hit_dice? && count <= hit_dice_remaining

    class_name = character_class.name.downcase
    self.hit_dice_used = hit_dice_used.merge(
      class_name => hit_dice_used_for_class + count
    )

    # Roll hit dice and heal
    total_healing = 0
    count.times do
      roll = rand(1..hit_dice_available)
      total_healing += roll + constitution_modifier
    end

    heal([total_healing, 0].max)
    save
  end

  def recover_hit_dice(type = 'long_rest')
    case type
    when 'long_rest'
      # Recover half hit dice (minimum 1)
      class_name = character_class.name.downcase
      recover_amount = [(level / 2).ceil, 1].max
      current_used = hit_dice_used_for_class

      self.hit_dice_used = hit_dice_used.merge(
        class_name => [current_used - recover_amount, 0].max
      )
      save
    end
  end

  # SPELLCASTING SYSTEM
  def is_spellcaster?
    spellcasting_ability.present?
  end

  def spellcasting_modifier
    return 0 unless is_spellcaster?
    ability_modifier(ability_score(spellcasting_ability))
  end

  def calculate_spell_save_dc
    return 0 unless is_spellcaster?
    8 + proficiency_bonus + spellcasting_modifier
  end

  def calculate_spell_attack_bonus
    return 0 unless is_spellcaster?
    proficiency_bonus + spellcasting_modifier
  end

  def has_spell_slots?(level)
    spell_slots.dig(level.to_s).to_i > 0
  end

  def spell_slots_for_level(level)
    spell_slots.dig(level.to_s) || 0
  end

  def spell_slots_used_for_level(level)
    spell_slots_used.dig(level.to_s) || 0
  end

  def spell_slots_remaining_for_level(level)
    spell_slots_for_level(level) - spell_slots_used_for_level(level)
  end

  def can_cast_spell?(spell, slot_level = nil)
    return false unless is_spellcaster?

    # Check if character knows the spell
    return false unless knows_spell?(spell)

    # Cantrips can always be cast
    return true if spell.cantrip?

    # Check if we have an appropriate spell slot
    cast_level = slot_level || spell.level
    return false if cast_level < spell.level

    spell_slots_remaining_for_level(cast_level) > 0
  end

  def cast_spell(spell, slot_level = nil)
    return false unless can_cast_spell?(spell, slot_level)

    # Cantrips don't use spell slots
    return true if spell.cantrip?

    # Use spell slot
    cast_level = slot_level || spell.level
    used_key = cast_level.to_s
    self.spell_slots_used = spell_slots_used.merge(
      used_key => spell_slots_used_for_level(cast_level) + 1
    )
    save
  end

  def recover_spell_slots(type = 'long_rest')
    case type
    when 'long_rest'
      self.spell_slots_used = {}
    when 'short_rest'
      # Some classes recover slots on short rest (Warlocks, etc.)
      # Implementation depends on class features
    end
    save
  end

  def knows_spell?(spell)
    character_spells.joins(:spell).where(spells: { id: spell.id }, known: true).exists?
  end

  def has_spell_prepared?(spell)
    character_spells.joins(:spell).where(spells: { id: spell.id }, prepared: true).exists?
  end

  def prepare_spell(spell)
    char_spell = character_spells.joins(:spell).find_by(spells: { id: spell.id })
    return false unless char_spell&.known?

    char_spell.update(prepared: true)
  end

  def unprepare_spell(spell)
    char_spell = character_spells.joins(:spell).find_by(spells: { id: spell.id })
    return false unless char_spell

    char_spell.update(prepared: false)
  end

  def learn_spell(spell, source: 'class', level_gained: nil)
    return false if knows_spell?(spell)

    character_spells.create!(
      spell: spell,
      known: true,
      prepared: prepared_caster? ? false : true,
      source: source,
      level_gained: level_gained || level
    )
  end

  def prepared_caster?
    %w[cleric druid paladin ranger wizard].include?(character_class.name.downcase)
  end

  def known_caster?
    %w[bard sorcerer warlock].include?(character_class.name.downcase)
  end

  def max_prepared_spells
    return 0 unless prepared_caster?

    modifier = spellcasting_modifier
    base = case character_class.name.downcase
    when 'cleric', 'druid' then modifier + level
    when 'paladin', 'ranger' then modifier + (level / 2).floor
    when 'wizard' then modifier + level
    else 0
    end

    [base, 1].max
  end

  def prepared_spells_count
    character_spells.where(prepared: true).joins(:spell).where.not(spells: { level: 0 }).count
  end

  def can_prepare_more_spells?
    prepared_caster? && prepared_spells_count < max_prepared_spells
  end

  def known_spells
    character_spells.where(known: true).includes(:spell)
  end

  def prepared_spells
    character_spells.where(prepared: true).includes(:spell)
  end

  def cantrips_known
    character_spells.joins(:spell).where(spells: { level: 0 }, known: true).includes(:spell)
  end

  def spells_by_level(level)
    character_spells.joins(:spell).where(spells: { level: level }, known: true).includes(:spell)
  end

  def knows_cantrip?(cantrip)
    cantrips_known.any? { |cs| cs.spell == cantrip }
  end

  def add_spell(spell)
    learn_spell(spell)
  end

  def add_cantrip(cantrip)
    learn_spell(cantrip)
  end

  # CONDITIONS & STATUS EFFECTS
  def has_condition?(condition)
    conditions.key?(condition)
  end

  def add_condition(condition, duration = nil, source = 'manual')
    self.conditions = conditions.merge(condition => {
      'applied_at' => Time.current,
      'duration' => duration,
      'source' => source
    })
    save
  end

  def remove_condition(condition)
    self.conditions = conditions.except(condition)
    save
  end

  def condition_duration(condition)
    conditions.dig(condition, 'duration')
  end

  def condition_source(condition)
    conditions.dig(condition, 'source')
  end

  def condition_applied_at(condition)
    conditions.dig(condition, 'applied_at')
  end

  def update_condition_durations
    conditions.each do |condition, data|
      if data['duration'] && data['duration'] > 0
        data['duration'] -= 1
        if data['duration'] <= 0
          remove_condition(condition)
        end
      end
    end
  end

  def has_advantage?(type, context = {})
    # Check for conditions that grant advantage
    return true if has_condition?('blessed') && type == 'saving_throw'
    return true if has_condition?('invisible') && type == 'attack'
    return true if has_condition?('hidden') && type == 'attack'
    return true if has_condition?('prone') && type == 'attack' && context[:range] == 'melee'
    return true if has_condition?('stunned') && type == 'attack' && context[:target] == self
    return true if has_condition?('paralyzed') && type == 'attack' && context[:target] == self
    return true if has_condition?('unconscious') && type == 'attack' && context[:target] == self
    return true if has_condition?('restrained') && type == 'attack' && context[:target] == self
    return true if has_condition?('blinded') && type == 'attack' && context[:target] == self

    false
  end

  def has_disadvantage?(type, context = {})
    # Check for conditions that impose disadvantage
    return true if has_condition?('poisoned') && type == 'attack'
    return true if has_condition?('frightened') && type == 'attack'
    return true if has_condition?('prone') && type == 'attack' && context[:range] == 'ranged'
    return true if has_condition?('blinded') && type == 'attack'
    return true if has_condition?('restrained') && type == 'attack'
    return true if has_condition?('exhaustion') && type.in?(['attack', 'ability_check'])
    return true if has_condition?('stunned') && type.in?(['attack', 'ability_check', 'saving_throw'])
    return true if has_condition?('paralyzed') && type.in?(['attack', 'ability_check', 'saving_throw'])
    return true if has_condition?('unconscious') && type.in?(['attack', 'ability_check', 'saving_throw'])

    false
  end

  def is_incapacitated?
    %w[unconscious stunned paralyzed].any? { |condition| has_condition?(condition) }
  end

  def can_act?
    !is_incapacitated?
  end

  def can_move?
    !has_condition?('paralyzed') && !has_condition?('stunned') && !has_condition?('unconscious') && !has_condition?('grappled')
  end

  def can_speak?
    !has_condition?('silenced') && !has_condition?('unconscious')
  end

  def can_concentrate?
    !has_condition?('unconscious') && !has_condition?('stunned') && !has_condition?('paralyzed')
  end

  def has_immunity?(damage_type)
    # Check for conditions or effects that grant immunity
    return true if has_condition?('rage') && damage_type == 'psychic'
    false
  end

  def has_resistance?(damage_type)
    # Check for conditions or effects that grant resistance
    return true if has_condition?('rage') && damage_type.in?(['bludgeoning', 'piercing', 'slashing'])
    false
  end

  def has_vulnerability?(damage_type)
    # Check for conditions or effects that grant vulnerability
    false
  end

  def apply_damage_modifiers(damage, damage_type)
    return 0 if has_immunity?(damage_type)
    damage = damage / 2 if has_resistance?(damage_type)
    damage = damage * 2 if has_vulnerability?(damage_type)
    damage.round
  end

  def movement_speed_modifier
    modifier = 0

    if has_condition?('prone')
      modifier -= movement_speed # Prone makes movement 0
    elsif has_condition?('restrained')
      modifier -= movement_speed # Restrained makes movement 0
    elsif has_condition?('grappled')
      modifier -= movement_speed # Grappled makes movement 0
    elsif has_condition?('exhaustion')
      exhaustion_level = conditions.dig('exhaustion', 'level') || 1
      modifier -= movement_speed / 2 if exhaustion_level >= 2
    end

    modifier
  end

  def effective_movement_speed
    base_speed = movement_speed + movement_speed_modifier
    [base_speed, 0].max
  end

  # EQUIPMENT & INVENTORY
  def carrying_weight
    character_items.joins(:item).sum('items.weight_lbs')
  end

  def is_encumbered?
    carrying_weight > carrying_capacity
  end

  def can_carry?(weight)
    carrying_weight + weight <= carrying_capacity
  end

  def total_currency_value
    currency_gp + (currency_sp / 10.0) + (currency_cp / 100.0)
  end

  def spend_currency(amount_gp)
    total_cp = (currency_gp * 100) + (currency_sp * 10) + currency_cp
    cost_cp = (amount_gp * 100).to_i

    return false if total_cp < cost_cp

    remaining_cp = total_cp - cost_cp
    self.currency_cp = remaining_cp % 10
    remaining_cp /= 10
    self.currency_sp = remaining_cp % 10
    self.currency_gp = remaining_cp / 10

    save
  end

  def gain_currency(gp: 0, sp: 0, cp: 0)
    self.currency_gp += gp
    self.currency_sp += sp
    self.currency_cp += cp

    # Convert excess cp to sp
    if self.currency_cp >= 10
      self.currency_sp += self.currency_cp / 10
      self.currency_cp = self.currency_cp % 10
    end

    # Convert excess sp to gp
    if self.currency_sp >= 10
      self.currency_gp += self.currency_sp / 10
      self.currency_sp = self.currency_sp % 10
    end

    save
  end

  def equipped_items
    character_items.where(equipped: true).includes(:item)
  end

  def unequipped_items
    character_items.where(equipped: false).includes(:item)
  end

  def equipped_weapons
    equipped_items.joins(:item).where(items: { item_type: 'weapon' })
  end

  def equipped_armor
    equipped_items.joins(:item).where(items: { item_type: 'armor' })
  end

  def equipped_shield
    equipped_items.joins(:item).where(items: { item_type: 'shield' })
  end

  def can_attune_to?(item)
    return false unless item.requires_attunement?
    return false if attuned_items.include?(item.id)
    return false if attuned_items.size >= attunement_slots

    true
  end

  def attune_to_item(item)
    return false unless can_attune_to?(item)

    self.attuned_items = attuned_items + [item.id]
    save
  end

  def unattune_from_item(item)
    self.attuned_items = attuned_items - [item.id]
    save
  end

  def is_attuned_to?(item)
    attuned_items.include?(item.id)
  end

  def attuned_items_count
    attuned_items.size
  end

  def available_attunement_slots
    attunement_slots - attuned_items_count
  end

  # ADVANCEMENT SYSTEM
  def xp_for_next_level
    case level
    when 1 then 300
    when 2 then 900
    when 3 then 2700
    when 4 then 6500
    when 5 then 14000
    when 6 then 23000
    when 7 then 34000
    when 8 then 48000
    when 9 then 64000
    when 10 then 85000
    when 11 then 100000
    when 12 then 120000
    when 13 then 140000
    when 14 then 165000
    when 15 then 195000
    when 16 then 225000
    when 17 then 265000
    when 18 then 305000
    when 19 then 355000
    else 999999
    end
  end

  def can_level_up?
    level < 20 && experience_points >= xp_for_next_level
  end

  def gain_experience(amount)
    self.experience_points += amount
    save
    check_level_up
  end

  def level_up!
    return false unless can_level_up?

    old_level = level
    self.level += 1

    # Recalculate derived stats
    self.proficiency_bonus = calculate_proficiency_bonus
    self.max_hp = calculate_max_hp
    self.current_hp = max_hp # Full heal on level up
    self.spell_save_dc = calculate_spell_save_dc
    self.spell_attack_bonus = calculate_spell_attack_bonus
    self.next_level_xp = xp_for_next_level

    # Grant class features for new level
    grant_class_features(level)

    save

    # Check for ability score improvement
    if [4, 8, 12, 16, 19].include?(level)
      # Character can choose ability score improvement or feat
      # This would typically be handled by the UI
    end

    level
  end

  def grant_class_features(level)
    features = character_class.class_feature_at_level(level)
    # Logic to grant specific features would go here
    # For now, just log what features should be granted
    Rails.logger.info "Character #{name} gained features at level #{level}: #{features.keys.join(', ')}"
  end

  # FEAT SYSTEM
  def has_feat?(feat_name)
    feats.exists?(name: feat_name)
  end

  def can_take_feat?(feat)
    return false if has_feat?(feat.name)
    feat.meets_prerequisites?(self)
  end

  def gain_feat(feat, options = {})
    return false unless can_take_feat?(feat)

    character_feats.create!(
      feat: feat,
      level_gained: level,
      selected_options: options
    )

    # Apply feat benefits
    apply_feat_benefits(feat, options)

    true
  end

  def apply_feat_benefits(feat, options)
    # Apply ability score increases
    if feat.half_feat? && options[:ability_increase]
      increase_ability_score(options[:ability_increase], 1)
    end

    # Apply proficiency bonuses
    if feat.benefits['proficiencies']
      feat.benefits['proficiencies'].each do |proficiency|
        add_proficiency('skill', proficiency)
      end
    end

    # Other feat benefits would be applied here
  end

  def increase_ability_score(ability, amount)
    score = ability_scores.find_by(score_type: ability.upcase)
    if score
      score.base_score = [score.base_score + amount, 20].min
      score.modified_score = score.base_score # Recalculate
      score.save
    end
  end

  private

  def calculate_derived_stats
    self.proficiency_bonus = calculate_proficiency_bonus
    self.max_hp = calculate_max_hp if max_hp.zero?
    self.current_hp = max_hp if current_hp.zero?
    self.armor_class = calculate_armor_class
    self.initiative_modifier = dexterity_modifier
    self.spell_save_dc = calculate_spell_save_dc
    self.spell_attack_bonus = calculate_spell_attack_bonus
    self.next_level_xp = xp_for_next_level
    self.carrying_capacity = strength * 15
  end

  def check_level_up
    level_up! if can_level_up?
  end
end
