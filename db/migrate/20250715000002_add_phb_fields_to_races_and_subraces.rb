class AddPhbFieldsToRacesAndSubraces < ActiveRecord::Migration[7.1]
  def change
    # Add fields to races table
    add_column :races, :description, :text
    add_column :races, :size, :string, default: "Medium" # Tiny, Small, Medium, Large, Huge, Gargantuan
    add_column :races, :speed, :integer, default: 30 # Base walking speed in feet
    add_column :races, :languages, :jsonb, default: [] # Array of languages known
    add_column :races, :proficiencies, :jsonb, default: {} # Skill/tool/weapon proficiencies
    add_column :races, :traits, :jsonb, default: {} # Racial traits like darkvision, fey ancestry, etc.
    add_column :races, :notes, :text # Additional racial features that don't fit other columns

    # Add fields to subraces table
    add_column :subraces, :description, :text
    add_column :subraces, :size, :string # Override race size if different
    add_column :subraces, :speed, :integer # Override race speed if different
    add_column :subraces, :languages, :jsonb, default: [] # Additional languages
    add_column :subraces, :proficiencies, :jsonb, default: {} # Additional proficiencies
    add_column :subraces, :traits, :jsonb, default: {} # Subrace-specific traits
    add_column :subraces, :spells, :jsonb, default: [] # Racial spells (like High Elf cantrip)
    add_column :subraces, :notes, :text # Additional subrace features

    # Add indexes for common queries
    add_index :races, :size
    add_index :subraces, :size
  end
end
