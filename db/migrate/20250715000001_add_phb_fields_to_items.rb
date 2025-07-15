class AddPhbFieldsToItems < ActiveRecord::Migration[7.1]
  def change
    # Basic item properties
    add_column :items, :description, :text
    add_column :items, :notes, :text # For complex/magical properties that don't fit other columns
    add_column :items, :rarity, :string, default: "common" # common, uncommon, rare, very_rare, legendary, artifact
    add_column :items, :cost_gp, :integer # Cost in gold pieces
    add_column :items, :weight_lbs, :decimal, precision: 8, scale: 2 # Weight in pounds
    add_column :items, :requires_attunement, :boolean, default: false

    # Weapon-specific properties
    add_column :items, :damage_dice, :string # e.g., "1d8", "2d6"
    add_column :items, :damage_type, :string # slashing, piercing, bludgeoning, etc.
    add_column :items, :weapon_type, :string # simple, martial
    add_column :items, :weapon_category, :string # melee, ranged
    add_column :items, :range_normal, :integer # Normal range in feet
    add_column :items, :range_long, :integer # Long range in feet
    add_column :items, :weapon_properties, :jsonb, default: {} # versatile, finesse, heavy, light, etc.

    # Armor-specific properties
    add_column :items, :armor_class, :integer # Base AC
    add_column :items, :armor_type, :string # light, medium, heavy, shield
    add_column :items, :max_dex_bonus, :integer # Max DEX bonus (null = no limit)
    add_column :items, :strength_requirement, :integer # Minimum STR required
    add_column :items, :stealth_disadvantage, :boolean, default: false

    # Magical properties
    add_column :items, :is_magical, :boolean, default: false
    add_column :items, :magic_bonus, :integer # +1, +2, +3 weapons/armor
    add_column :items, :spell_attack_bonus, :integer # For spell focus items
    add_column :items, :spell_save_dc_bonus, :integer # For spell focus items

    # Usage and charges
    add_column :items, :max_charges, :integer # For items with limited uses
    add_column :items, :charges_per_day, :integer # How many charges restored per day
    add_column :items, :consumable, :boolean, default: false # Single-use items

    # Add index for common queries
    add_index :items, :item_type
    add_index :items, :rarity
    add_index :items, :weapon_type
    add_index :items, :armor_type
    add_index :items, :is_magical
  end
end
