class AddCorePhbFeaturesToCharacters < ActiveRecord::Migration[7.1]
  def change
    # Add core character stats
    add_column :characters, :current_hp, :integer, default: 0
    add_column :characters, :temporary_hp, :integer, default: 0
    add_column :characters, :armor_class, :integer, default: 10
    add_column :characters, :initiative_modifier, :integer, default: 0
    add_column :characters, :proficiency_bonus, :integer, default: 2
    add_column :characters, :inspiration, :boolean, default: false

    # Add advancement tracking
    add_column :characters, :experience_points, :integer, default: 0
    add_column :characters, :next_level_xp, :integer, default: 300

    # Add equipment tracking
    add_column :characters, :carrying_capacity, :integer, default: 150
    add_column :characters, :currency_gp, :integer, default: 0
    add_column :characters, :currency_sp, :integer, default: 0
    add_column :characters, :currency_cp, :integer, default: 0

    # Add proficiencies
    add_column :characters, :skill_proficiencies, :jsonb, default: []
    add_column :characters, :skill_expertise, :jsonb, default: []
    add_column :characters, :weapon_proficiencies, :jsonb, default: []
    add_column :characters, :armor_proficiencies, :jsonb, default: []
    add_column :characters, :tool_proficiencies, :jsonb, default: []
    add_column :characters, :language_proficiencies, :jsonb, default: []

    # Add spellcasting
    add_column :characters, :spellcasting_ability, :string
    add_column :characters, :spell_save_dc, :integer, default: 8
    add_column :characters, :spell_attack_bonus, :integer, default: 0
    add_column :characters, :spell_slots, :jsonb, default: {}
    add_column :characters, :spells_known, :jsonb, default: []
    add_column :characters, :cantrips_known, :jsonb, default: []

    # Add conditions/status effects
    add_column :characters, :conditions, :jsonb, default: {}
    add_column :characters, :temporary_effects, :jsonb, default: {}

    # Add indexes for performance
    add_index :characters, :level
    add_index :characters, :experience_points
    add_index :characters, :skill_proficiencies, using: :gin
    add_index :characters, :conditions, using: :gin
  end
end
