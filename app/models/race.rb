class Race < ApplicationRecord
  has_many :subraces, dependent: :destroy
  has_many :characters, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :size, inclusion: { in: %w[Tiny Small Medium Large Huge Gargantuan] }
  validates :speed, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :by_size, ->(size) { where(size: size) }
  scope :with_trait, ->(trait) { where("traits ? :trait", trait: trait) }
  scope :with_language, ->(language) { where("languages @> ?", [language].to_json) }

  # Methods
  def has_trait?(trait)
    traits.key?(trait) && traits[trait]
  end

  def knows_language?(language)
    languages.include?(language)
  end

  def has_proficiency?(type, proficiency)
    proficiencies.dig(type)&.include?(proficiency) || false
  end

  def trait_description(trait)
    return nil unless has_trait?(trait)
    traits[trait].is_a?(Hash) ? traits[trait]['description'] : nil
  end

  def display_languages
    return "None" if languages.empty?
    languages.join(", ")
  end

  def display_size_and_speed
    "#{size}, #{speed} ft"
  end
end
