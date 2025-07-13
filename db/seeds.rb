# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
BattleParticipant.delete_all  # ← MISSING - this references characters
Battle.delete_all             # ← MISSING - this references users
CharacterItem.delete_all
AbilityScore.delete_all
Character.delete_all
User.delete_all
Subclass.delete_all
CharacterClass.delete_all
Subrace.delete_all
Race.delete_all
Item.delete_all

# === RACES & SUBRACES ===
race_human = Race.create!(name: "Human")
subrace_variant_human = Subrace.create!(name: "Variant Human", race: race_human, ability_modifiers: { "STR" => 1, "DEX" => 1 })
subrace_standard_human = Subrace.create!(name: "Standard Human", race: race_human, ability_modifiers: { "STR" => 1, "DEX" => 1, "CON" => 1, "INT" => 1, "WIS" => 1, "CHA" => 1 })

race_elf = Race.create!(name: "Elf")
subrace_high_elf = Subrace.create!(name: "High Elf", race: race_elf, ability_modifiers: { "DEX" => 2, "INT" => 1 })
subrace_wood_elf = Subrace.create!(name: "Wood Elf", race: race_elf, ability_modifiers: { "DEX" => 2, "WIS" => 1 })

race_dwarf = Race.create!(name: "Dwarf")
subrace_hill_dwarf = Subrace.create!(name: "Hill Dwarf", race: race_dwarf, ability_modifiers: { "CON" => 2, "WIS" => 1 })
subrace_mountain_dwarf = Subrace.create!(name: "Mountain Dwarf", race: race_dwarf, ability_modifiers: { "CON" => 2, "STR" => 2 })

# === CLASSES & SUBCLASSES ===
class_barbarian = CharacterClass.create!(name: "Barbarian", ability_requirements: {}, bonuses: {})
subclass_berserker = Subclass.create!(name: "Path of the Berserker", character_class: class_barbarian, bonuses: { "rage_bonus" => true })
subclass_totem = Subclass.create!(name: "Path of the Totem Warrior", character_class: class_barbarian, bonuses: { "animal_spirit" => true })

class_fighter = CharacterClass.create!(name: "Fighter", ability_requirements: {}, bonuses: {})
subclass_champion = Subclass.create!(name: "Champion", character_class: class_fighter, bonuses: { "extra_attack" => true })
subclass_battlemaster = Subclass.create!(name: "Battle Master", character_class: class_fighter, bonuses: { "combat_superiority" => true })

class_rogue = CharacterClass.create!(name: "Rogue", ability_requirements: {}, bonuses: {})
subclass_thief = Subclass.create!(name: "Thief", character_class: class_rogue, bonuses: { "fast_hands" => true })
subclass_assassin = Subclass.create!(name: "Assassin", character_class: class_rogue, bonuses: { "sneak_attack" => true })

# === ITEMS ===
items = [
  # Boots
  { name: "Leather Boots", item_type: "boots", bonuses: { "DEX" => 1 } },
  { name: "Silent Step Boots", item_type: "boots", bonuses: { "DEX" => 2 } },
  { name: "Boots of Endurance", item_type: "boots", bonuses: { "CON" => 1 } },
  { name: "Scout’s Treads", item_type: "boots", bonuses: { "WIS" => 1 } },

  # Gloves
  { name: "Steel Gloves", item_type: "gloves", bonuses: { "STR" => 1 } },
  { name: "Gloves of Finesse", item_type: "gloves", bonuses: { "DEX" => 1 } },
  { name: "Mason’s Grip", item_type: "gloves", bonuses: { "CON" => 2 } },
  { name: "Arcane Mitts", item_type: "gloves", bonuses: { "INT" => 1 } },

  # Necklaces
  { name: "Silver Necklace", item_type: "necklace", bonuses: { "CHA" => 1 } },
  { name: "Amulet of Focus", item_type: "necklace", bonuses: { "INT" => 2 } },
  { name: "Cleric’s Beads", item_type: "necklace", bonuses: { "WIS" => 1 } },
  { name: "Warrior’s Chain", item_type: "necklace", bonuses: { "STR" => 1 } },

  # Rings
  { name: "Golden Ring", item_type: "ring", bonuses: { "WIS" => 1 } },
  { name: "Band of Agility", item_type: "ring", bonuses: { "DEX" => 2 } },
  { name: "Ring of Vitality", item_type: "ring", bonuses: { "CON" => 1 } },
  { name: "Enchanter’s Loop", item_type: "ring", bonuses: { "INT" => 1 } },

  # Weapons
  { name: "Short Sword", item_type: "weapon", bonuses: { "STR" => 1 } },
  { name: "Dagger of Precision", item_type: "weapon", bonuses: { "DEX" => 2 } },
  { name: "Battle Axe", item_type: "weapon", bonuses: { "STR" => 2 } },
  { name: "Wand of Sparks", item_type: "weapon", bonuses: { "INT" => 1 } },

  # Armor
  { name: "Chain Armor", item_type: "armor", bonuses: { "CON" => 1 } },
  { name: "Padded Armor", item_type: "armor", bonuses: { "DEX" => 1 } },
  { name: "Scale Mail", item_type: "armor", bonuses: { "CON" => 2 } },
  { name: "Mage Robes", item_type: "armor", bonuses: { "INT" => 1 } }
]

item_records = items.map { |i| Item.create!(i) }


# === USERS & CHARACTERS ===

# User 1
user1 = User.create!(first_name: "Ayla", last_name: "Rivers", email: "ayla@example.com")

char1 = Character.create!(name: "Thorne", user: user1, race: race_human, subrace: subrace_variant_human, character_class: class_barbarian, subclass: subclass_totem)
char2 = Character.create!(name: "Nim", user: user1, race: race_elf, subrace: subrace_high_elf, character_class: class_rogue, subclass: subclass_assassin)
char3 = Character.create!(name: "Durgan", user: user1, race: race_dwarf, subrace: subrace_mountain_dwarf, character_class: class_fighter, subclass: subclass_battlemaster)
char4 = Character.create!(name: "Sera", user: user1, race: race_elf, subrace: subrace_wood_elf, character_class: class_rogue, subclass: subclass_thief)
char5 = Character.create!(name: "Bram", user: user1, race: race_human, subrace: subrace_standard_human, character_class: class_fighter, subclass: subclass_champion)

# User 2
user2 = User.create!(first_name: "Kellen", last_name: "Voss", email: "kellen@example.com")

char6 = Character.create!(name: "Kael", user: user2, race: race_elf, subrace: subrace_high_elf, character_class: class_fighter, subclass: subclass_battlemaster)
char7 = Character.create!(name: "Lira", user: user2, race: race_dwarf, subrace: subrace_hill_dwarf, character_class: class_barbarian, subclass: subclass_berserker)
char8 = Character.create!(name: "Tovin", user: user2, race: race_human, subrace: subrace_variant_human, character_class: class_rogue, subclass: subclass_thief)
char9 = Character.create!(name: "Runa", user: user2, race: race_elf, subrace: subrace_wood_elf, character_class: class_rogue, subclass: subclass_assassin)
char10 = Character.create!(name: "Brek", user: user2, race: race_dwarf, subrace: subrace_mountain_dwarf, character_class: class_barbarian, subclass: subclass_totem)

# User 3
user3 = User.create!(first_name: "Mira", last_name: "Dalca", email: "mira@example.com")

char11 = Character.create!(name: "Finn", user: user3, race: race_human, subrace: subrace_standard_human, character_class: class_fighter, subclass: subclass_champion)
char12 = Character.create!(name: "Vex", user: user3, race: race_elf, subrace: subrace_high_elf, character_class: class_rogue, subclass: subclass_assassin)
char13 = Character.create!(name: "Orla", user: user3, race: race_dwarf, subrace: subrace_hill_dwarf, character_class: class_barbarian, subclass: subclass_berserker)
char14 = Character.create!(name: "Thia", user: user3, race: race_elf, subrace: subrace_wood_elf, character_class: class_fighter, subclass: subclass_battlemaster)
char15 = Character.create!(name: "Jarek", user: user3, race: race_human, subrace: subrace_variant_human, character_class: class_barbarian, subclass: subclass_totem)

# === ABILITY SCORES ===
def set_scores(character, scores)
  scores.each do |score_type, value|
    AbilityScore.create!(
      character: character,
      score_type: score_type,
      base_score: value[:base],
      modified_score: value[:modified]
    )
  end
end

# (for brevity, these are just sample scores for one character, repeat similar for others)
set_scores(char1, {
  "STR" => { base: 15, modified: 16 },
  "DEX" => { base: 13, modified: 14 },
  "CON" => { base: 12, modified: 12 },
  "INT" => { base: 10, modified: 10 },
  "WIS" => { base: 11, modified: 11 },
  "CHA" => { base: 9, modified: 9 }
})

set_scores(char2, {
  "STR" => { base: 11, modified: 11 },
  "DEX" => { base: 15, modified: 17 },
  "CON" => { base: 9, modified: 9 },
  "INT" => { base: 13, modified: 14 },
  "WIS" => { base: 11, modified: 11 },
  "CHA" => { base: 11, modified: 11 }
})

set_scores(char3, {
  "STR" => { base: 11, modified: 13 },
  "DEX" => { base: 12, modified: 12 },
  "CON" => { base: 8, modified: 10 },
  "INT" => { base: 14, modified: 14 },
  "WIS" => { base: 9, modified: 9 },
  "CHA" => { base: 14, modified: 14 }
})

set_scores(char4, {
  "STR" => { base: 8, modified: 8 },
  "DEX" => { base: 11, modified: 13 },
  "CON" => { base: 9, modified: 9 },
  "INT" => { base: 15, modified: 15 },
  "WIS" => { base: 15, modified: 16 },
  "CHA" => { base: 12, modified: 12 }
})

set_scores(char5, {
  "STR" => { base: 10, modified: 11 },
  "DEX" => { base: 14, modified: 15 },
  "CON" => { base: 11, modified: 12 },
  "INT" => { base: 9, modified: 10 },
  "WIS" => { base: 14, modified: 15 },
  "CHA" => { base: 9, modified: 10 }
})

set_scores(char6, {
  "STR" => { base: 12, modified: 12 },
  "DEX" => { base: 13, modified: 15 },
  "CON" => { base: 12, modified: 12 },
  "INT" => { base: 8, modified: 9 },
  "WIS" => { base: 12, modified: 12 },
  "CHA" => { base: 14, modified: 14 }
})

set_scores(char7, {
  "STR" => { base: 15, modified: 15 },
  "DEX" => { base: 10, modified: 10 },
  "CON" => { base: 10, modified: 12 },
  "INT" => { base: 13, modified: 13 },
  "WIS" => { base: 15, modified: 16 },
  "CHA" => { base: 9, modified: 9 }
})

set_scores(char8, {
  "STR" => { base: 15, modified: 16 },
  "DEX" => { base: 8, modified: 9 },
  "CON" => { base: 15, modified: 15 },
  "INT" => { base: 15, modified: 15 },
  "WIS" => { base: 15, modified: 15 },
  "CHA" => { base: 13, modified: 13 }
})

set_scores(char9, {
  "STR" => { base: 15, modified: 15 },
  "DEX" => { base: 11, modified: 13 },
  "CON" => { base: 10, modified: 10 },
  "INT" => { base: 8, modified: 8 },
  "WIS" => { base: 15, modified: 16 },
  "CHA" => { base: 13, modified: 13 }
})

set_scores(char10, {
  "STR" => { base: 13, modified: 15 },
  "DEX" => { base: 11, modified: 11 },
  "CON" => { base: 12, modified: 14 },
  "INT" => { base: 12, modified: 12 },
  "WIS" => { base: 9, modified: 9 },
  "CHA" => { base: 9, modified: 9 }
})

set_scores(char11, {
  "STR" => { base: 12, modified: 13 },
  "DEX" => { base: 11, modified: 12 },
  "CON" => { base: 14, modified: 15 },
  "INT" => { base: 14, modified: 15 },
  "WIS" => { base: 15, modified: 16 },
  "CHA" => { base: 15, modified: 16 }
})

set_scores(char12, {
  "STR" => { base: 12, modified: 12 },
  "DEX" => { base: 15, modified: 17 },
  "CON" => { base: 10, modified: 10 },
  "INT" => { base: 10, modified: 11 },
  "WIS" => { base: 11, modified: 11 },
  "CHA" => { base: 8, modified: 8 }
})

set_scores(char13, {
  "STR" => { base: 14, modified: 14 },
  "DEX" => { base: 9, modified: 9 },
  "CON" => { base: 11, modified: 13 },
  "INT" => { base: 15, modified: 15 },
  "WIS" => { base: 11, modified: 12 },
  "CHA" => { base: 9, modified: 9 }
})

set_scores(char14, {
  "STR" => { base: 12, modified: 12 },
  "DEX" => { base: 8, modified: 10 },
  "CON" => { base: 9, modified: 9 },
  "INT" => { base: 13, modified: 13 },
  "WIS" => { base: 15, modified: 16 },
  "CHA" => { base: 10, modified: 10 }
})

set_scores(char15, {
  "STR" => { base: 9, modified: 10 },
  "DEX" => { base: 15, modified: 16 },
  "CON" => { base: 9, modified: 9 },
  "INT" => { base: 8, modified: 8 },
  "WIS" => { base: 14, modified: 14 },
  "CHA" => { base: 11, modified: 11 }
})

# Repeat similar calls to `set_scores` for char2 through char15 with different stat blocks
# (you can either hand-type them or I can expand this seed file further if you’d like full stats for all 15)

# === ASSIGN ITEMS TO CHARACTERS ===
[ char1, char2, char3, char4, char5, char6, char7, char8, char9, char10, char11, char12, char13, char14, char15 ].each do |char|
  CharacterItem.create!(character: char, item: item_records.sample)
  CharacterItem.create!(character: char, item: item_records.sample)
end

# === ASSIGN ITEMS TO CHARACTERS ===
[ char1, char2, char3, char4, char5, char6, char7, char8, char9, char10, char11, char12, char13, char14, char15 ].each do |char|
  char.update!(movement_speed: 30) # or 25 for dwarves
end

# === GENERATE BATTLE BOARD ===
board = BattleServices::BoardGenerator.new(name: "Training Grounds").run

# === TEST BATTLE ===
battle = Battle.create!(player_1: User.first, player_2: User.second, status: "pending", battle_board: board)

team1 = User.first.characters.limit(3)
team2 = User.second.characters.limit(3)

BattleServices::BattleInitializer.new(battle, team1, team2).run

rage = Ability.create!(
  name: "Rage",
  class_name: "Barbarian",
  level_required: 1,
  action_type: "active",
  description: "Gain +2 damage and resistance to physical for 3 turns.",
  cooldown_turns: 5
)

sneak = Ability.create!(
  name: "Sneak Attack",
  class_name: "Rogue",
  level_required: 1,
  action_type: "passive",
  description: "Deal +1d6 damage when you have advantage.",
  cooldown_turns: 0
)

Character.all.each do |char|
  case char.character_class.name
  when "Barbarian"
    CharacterAbility.create!(character: char, ability: rage, uses_remaining: 1)
  when "Rogue"
    CharacterAbility.create!(character: char, ability: sneak, uses_remaining: nil)
  end
end
