class AddPhbFieldsToClassesAndAbilities < ActiveRecord::Migration[7.1]
  def change
    # Add fields to character_classes table
    add_column :character_classes, :description, :text
    add_column :character_classes, :hit_die, :integer, default: 8 # d6=6, d8=8, d10=10, d12=12
    add_column :character_classes, :primary_ability, :jsonb, default: [] # Primary abilities for the class
    add_column :character_classes, :saving_throw_proficiencies, :jsonb, default: [] # Proficient saving throws
    add_column :character_classes, :skill_proficiencies, :jsonb, default: {} # Available skills and number to choose
    add_column :character_classes, :weapon_proficiencies, :jsonb, default: [] # Weapon proficiencies
    add_column :character_classes, :armor_proficiencies, :jsonb, default: [] # Armor proficiencies
    add_column :character_classes, :tool_proficiencies, :jsonb, default: [] # Tool proficiencies
    add_column :character_classes, :starting_equipment, :jsonb, default: {} # Starting equipment options
    add_column :character_classes, :spellcasting, :jsonb, default: {} # Spellcasting info (ability, ritual, etc.)
    add_column :character_classes, :class_features, :jsonb, default: {} # Level-based class features
    add_column :character_classes, :multiclass_requirements, :jsonb, default: {} # Multiclass prerequisites
    add_column :character_classes, :notes, :text # Additional class features

    # Add fields to subclasses table
    add_column :subclasses, :description, :text
    add_column :subclasses, :subclass_features, :jsonb, default: {} # Level-based subclass features
    add_column :subclasses, :spells, :jsonb, default: [] # Subclass-specific spells
    add_column :subclasses, :proficiencies, :jsonb, default: {} # Additional proficiencies
    add_column :subclasses, :notes, :text # Additional subclass features

    # Add fields to abilities table
    add_column :abilities, :ability_type, :string # class_feature, racial_trait, feat, spell, etc.
    add_column :abilities, :source, :string # Class name, race name, feat name, etc.
    add_column :abilities, :prerequisites, :jsonb, default: {} # Level, stats, other requirements
    add_column :abilities, :components, :jsonb, default: {} # Verbal, somatic, material components
    add_column :abilities, :duration, :string # Instantaneous, concentration, permanent, etc.
    add_column :abilities, :range, :string # Self, touch, 30 feet, etc.
    add_column :abilities, :area_of_effect, :string # 15-foot cone, 20-foot radius, etc.
    add_column :abilities, :damage_dice, :string # Damage dice if applicable
    add_column :abilities, :damage_type, :string # Damage type if applicable
    add_column :abilities, :saving_throw, :string # Required saving throw
    add_column :abilities, :uses_per_rest, :string # short_rest, long_rest, unlimited
    add_column :abilities, :max_uses, :integer # Maximum uses per rest
    add_column :abilities, :recharge, :string # Recharge condition (e.g., "5-6 on d6")
    add_column :abilities, :scaling, :jsonb, default: {} # How ability scales with level
    add_column :abilities, :notes, :text # Additional ability mechanics

    # Add indexes for common queries
    add_index :character_classes, :hit_die
    add_index :character_classes, :primary_ability, using: :gin
    add_index :subclasses, :spells, using: :gin
    add_index :abilities, :ability_type
    add_index :abilities, :source
    add_index :abilities, :level_required
    add_index :abilities, :action_type
  end
end
