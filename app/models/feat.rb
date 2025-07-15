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
end
