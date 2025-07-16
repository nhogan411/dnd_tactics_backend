class Feat < ApplicationRecord
  has_many :character_feats, dependent: :destroy
  has_many :characters, through: :character_feats

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, presence: true

  scope :half_feats, -> { where(half_feat: true) }
  scope :full_feats, -> { where(half_feat: false) }

  def has_prerequisites?
    prerequisites.present? && prerequisites.any?
  end

  def meets_prerequisites?(character)
    return true unless has_prerequisites?

    prerequisites.all? do |req_type, req_value|
      case req_type
      when 'ability_score'
        req_value.all? { |ability, min_score| character.ability_score(ability) >= min_score }
      when 'proficiency'
        req_value.all? { |prof_type, proficiency| character.has_proficiency?(prof_type, proficiency) }
      when 'class'
        character.character_class.name == req_value
      when 'race'
        character.race.name == req_value
      when 'level'
        character.level >= req_value
      when 'spellcasting'
        character.spellcasting_ability.present?
      else
        true
      end
    end
  end

  def is_half_feat?
    half_feat
  end

  def ability_score_options
    ability_score_increases.keys
  end

  def display_prerequisites
    return "None" unless has_prerequisites?

    prereq_strings = prerequisites.map do |type, value|
      case type
      when 'ability_score'
        value.map { |ability, score| "#{ability} #{score}+" }.join(", ")
      when 'proficiency'
        "Proficiency with #{value}"
      when 'class'
        "#{value} class"
      when 'race'
        "#{value} race"
      when 'level'
        "Level #{value}+"
      when 'spellcasting'
        "Ability to cast spells"
      else
        "#{type}: #{value}"
      end
    end

    prereq_strings.join("; ")
  end

  def display_benefits
    return "No benefits listed" if benefits.empty?

    benefit_strings = benefits.map do |type, value|
      case type
      when 'ability_scores'
        "Increase #{value.keys.join(' or ')} by #{value.values.first}"
      when 'proficiencies'
        "Gain proficiency with #{value.join(', ')}"
      when 'spells'
        "Learn #{value.join(', ')}"
      when 'special'
        value
      else
        "#{type.humanize}: #{value}"
      end
    end

    benefit_strings.join("; ")
  end

  # Feat application helpers
  def apply_to_character(character, options = {})
    return false unless meets_prerequisites?(character)

    # Apply ability score increases
    if half_feat? && options[:ability_increase]
      character.increase_ability_score(options[:ability_increase], 1)
    end

    # Apply other benefits
    apply_benefits(character, options)

    true
  end

  def apply_benefits(character, options = {})
    return if benefits.empty?

    benefits.each do |type, value|
      case type
      when 'proficiencies'
        value.each do |proficiency|
          character.add_proficiency('skill', proficiency)
        end
      when 'spells'
        value.each do |spell_name|
          spell = Spell.find_by(name: spell_name)
          character.learn_spell(spell, source: 'feat') if spell
        end
      when 'special'
        # Handle special feat benefits - would need custom logic per feat
        apply_special_benefit(character, value, options)
      end
    end
  end

  def apply_special_benefit(character, benefit_description, options)
    # This would contain custom logic for each feat's special benefits
    # For now, just log it
    Rails.logger.info "Applied special benefit for feat #{name}: #{benefit_description}"
  end

  def compatible_with_character?(character)
    # Check if feat makes sense for the character's build
    return false if character.has_feat?(name)
    return false unless meets_prerequisites?(character)

    true
  end

  def recommended_for_class?(class_name)
    # Simple heuristic based on feat benefits and class synergy
    return true if benefits.key?('spells') && ['wizard', 'sorcerer', 'warlock'].include?(class_name.downcase)
    return true if benefits.key?('proficiencies') && benefits['proficiencies'].include?('Athletics') && ['fighter', 'barbarian'].include?(class_name.downcase)

    false
  end

  # Audit and summary methods
  def audit
    {
      name: name,
      description: description,
      half_feat: half_feat,
      prerequisites: prerequisites,
      benefits: benefits,
      ability_score_increases: ability_score_increases,
      prerequisite_text: display_prerequisites,
      benefit_text: display_benefits
    }
  end

  def summary_hash
    {
      id: id,
      name: name,
      description: description,
      half_feat: half_feat,
      prerequisites: display_prerequisites,
      benefits: display_benefits
    }
  end
end
