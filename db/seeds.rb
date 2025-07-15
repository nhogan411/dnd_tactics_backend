# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
BattleParticipant.delete_all
Battle.delete_all
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
# PHB Races with comprehensive data mapping

# === HUMAN ===
race_human = Race.create!(
  name: "Human",
  description: "In the reckonings of most worlds, humans are the youngest of the common races, late to arrive on the world scene and short-lived in comparison to dwarves, elves, and dragons.",
  size: "Medium",
  speed: 30,
  languages: ["Common"],
  proficiencies: {},
  traits: {
    "extra_language" => { "description" => "You can speak, read, and write one extra language of your choice." },
    "extra_skill" => { "description" => "You gain proficiency in one skill of your choice." },
    "versatile" => { "description" => "Humans are adaptable and ambitious." }
  },
  notes: "Humans are the most adaptable and ambitious people among the common races. They have widely varying tastes, morals, and customs."
)

subrace_variant_human = Subrace.create!(
  name: "Variant Human",
  race: race_human,
  description: "If your campaign uses the optional feat rules, your human character can forgo the Ability Score Increase trait to take a feat of your choice instead.",
  ability_modifiers: { "STR" => 1, "DEX" => 1 },
  proficiencies: { "skills" => ["one_skill_of_choice"] },
  traits: {
    "feat" => { "description" => "You gain one feat of your choice." },
    "extra_skill" => { "description" => "You gain proficiency in one skill of your choice." }
  },
  notes: "Variant humans trade the standard +1 to all abilities for +1 to two different abilities, an extra skill, and a feat at 1st level."
)

subrace_standard_human = Subrace.create!(
  name: "Standard Human",
  race: race_human,
  description: "The standard human gains a small increase to all ability scores.",
  ability_modifiers: { "STR" => 1, "DEX" => 1, "CON" => 1, "INT" => 1, "WIS" => 1, "CHA" => 1 },
  proficiencies: { "skills" => ["one_skill_of_choice"] },
  traits: {
    "versatile" => { "description" => "Humans are adaptable and gain +1 to all ability scores." }
  },
  notes: "Standard humans are well-rounded, gaining a +1 bonus to all ability scores."
)

# === ELF ===
race_elf = Race.create!(
  name: "Elf",
  description: "Elves are a magical people of otherworldly grace, living in the world but not entirely part of it.",
  size: "Medium",
  speed: 30,
  languages: ["Common", "Elvish"],
  proficiencies: { "skills" => ["Perception"] },
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "keen_senses" => { "description" => "You have proficiency in the Perception skill." },
    "fey_ancestry" => { "description" => "You have advantage on saving throws against being charmed, and magic can't put you to sleep." },
    "trance" => { "description" => "Elves don't need to sleep. Instead, they meditate deeply for 4 hours and gain the same benefit as a human's 8-hour sleep." }
  },
  notes: "Elves are magical beings with natural grace, keen senses, and resistance to charm effects."
)

subrace_high_elf = Subrace.create!(
  name: "High Elf",
  race: race_elf,
  description: "High elves are the most common variety of elves. They are more haughty and reclusive than their cousins.",
  ability_modifiers: { "DEX" => 2, "INT" => 1 },
  proficiencies: {
    "weapons" => ["longsword", "shortbow", "longbow", "shortsword"],
    "skills" => []
  },
  traits: {
    "elf_weapon_training" => { "description" => "You have proficiency with longswords, shortswords, shortbows, and longbows." },
    "cantrip" => { "description" => "You know one cantrip of your choice from the wizard spell list. Intelligence is your spellcasting ability for it." }
  },
  spells: ["one_wizard_cantrip"],
  notes: "High elves are skilled with weapons and magic, gaining weapon proficiencies and a wizard cantrip."
)

subrace_wood_elf = Subrace.create!(
  name: "Wood Elf",
  race: race_elf,
  description: "Wood elves have keen senses and intuition, and their fleet feet carry them quickly through their forest homes.",
  ability_modifiers: { "DEX" => 2, "WIS" => 1 },
  proficiencies: {
    "weapons" => ["longsword", "shortbow", "longbow", "shortsword"],
    "armor" => ["leather_armor"],
    "skills" => []
  },
  traits: {
    "elf_weapon_training" => { "description" => "You have proficiency with longswords, shortswords, shortbows, and longbows." },
    "fleet_of_foot" => { "description" => "Your base walking speed increases to 35 feet." },
    "mask_of_the_wild" => { "description" => "You can attempt to hide even when you are only lightly obscured by foliage, heavy rain, falling snow, mist, and other natural phenomena." }
  },
  speed: 35,
  notes: "Wood elves are swift and stealthy, with increased speed and the ability to hide in natural cover."
)

# === DWARF ===
race_dwarf = Race.create!(
  name: "Dwarf",
  description: "Bold and hardy, dwarves are known as skilled warriors, miners, and workers of stone and metal.",
  size: "Medium",
  speed: 25,
  languages: ["Common", "Dwarvish"],
  proficiencies: {
    "weapons" => ["battleaxe", "handaxe", "light_hammer", "warhammer"],
    "tools" => ["smith_tools", "brewer_supplies", "mason_tools"]
  },
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "dwarven_resilience" => { "description" => "You have advantage on saving throws against poison, and you have resistance against poison damage." },
    "dwarven_combat_training" => { "description" => "You have proficiency with the battleaxe, handaxe, light hammer, and warhammer." },
    "tool_proficiency" => { "description" => "You gain proficiency with one type of artisan's tools of your choice." },
    "stonecunning" => { "description" => "Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient and add double your proficiency bonus." }
  },
  notes: "Dwarves are resilient mountain folk with natural resistance to poison and expertise with weapons and tools."
)

subrace_hill_dwarf = Subrace.create!(
  name: "Hill Dwarf",
  race: race_dwarf,
  description: "Hill dwarves are the most common variety of dwarves.",
  ability_modifiers: { "CON" => 2, "WIS" => 1 },
  traits: {
    "dwarven_toughness" => { "description" => "Your hit point maximum increases by 1, and it increases by 1 every time you gain a level." }
  },
  notes: "Hill dwarves are hardy folk with increased hit points, making them naturally tougher than other dwarves."
)

subrace_mountain_dwarf = Subrace.create!(
  name: "Mountain Dwarf",
  race: race_dwarf,
  description: "Mountain dwarves are strong and hardy, accustomed to a difficult life in rugged terrain.",
  ability_modifiers: { "CON" => 2, "STR" => 2 },
  proficiencies: {
    "armor" => ["light_armor", "medium_armor"]
  },
  traits: {
    "armor_proficiency" => { "description" => "You have proficiency with light and medium armor." }
  },
  notes: "Mountain dwarves are strong warriors with natural armor proficiency and increased strength."
)

# === HALFLING ===
race_halfling = Race.create!(
  name: "Halfling",
  description: "The diminutive halflings survive in a world full of larger creatures by avoiding notice or, barring that, avoiding offense.",
  size: "Small",
  speed: 25,
  languages: ["Common", "Halfling"],
  proficiencies: {},
  traits: {
    "lucky" => { "description" => "When you roll a 1 on the d20 for an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll." },
    "brave" => { "description" => "You have advantage on saving throws against being frightened." },
    "halfling_nimbleness" => { "description" => "You can move through the space of any creature that is of a size larger than yours." }
  },
  notes: "Halflings are small, nimble folk known for their luck and bravery despite their size."
)

subrace_lightfoot_halfling = Subrace.create!(
  name: "Lightfoot Halfling",
  race: race_halfling,
  description: "Lightfoot halflings can easily hide from notice, even using other people as cover.",
  ability_modifiers: { "DEX" => 2, "CHA" => 1 },
  traits: {
    "naturally_stealthy" => { "description" => "You can attempt to hide even when you are obscured only by a creature that is at least one size larger than you." }
  },
  notes: "Lightfoot halflings are charismatic and naturally stealthy, able to hide behind larger creatures."
)

subrace_stout_halfling = Subrace.create!(
  name: "Stout Halfling",
  race: race_halfling,
  description: "Stout halflings are hardier than average and have some resistance to poison.",
  ability_modifiers: { "DEX" => 2, "CON" => 1 },
  traits: {
    "stout_resilience" => { "description" => "You have advantage on saving throws against poison, and you have resistance against poison damage." }
  },
  notes: "Stout halflings are tougher than their lightfoot cousins, with resistance to poison like dwarves."
)

# === DRAGONBORN ===
race_dragonborn = Race.create!(
  name: "Dragonborn",
  description: "Born of dragons, as their name proclaims, the dragonborn walk proudly through a world that greets them with fearful incomprehension.",
  size: "Medium",
  speed: 30,
  languages: ["Common", "Draconic"],
  proficiencies: {},
  traits: {
    "draconic_ancestry" => { "description" => "You have draconic ancestry. Choose one type of dragon. Your breath weapon and damage resistance are determined by the dragon type." },
    "breath_weapon" => { "description" => "You can use your action to exhale destructive energy. Each creature in the area must make a saving throw, the type of which is determined by your draconic ancestry." },
    "damage_resistance" => { "description" => "You have resistance to the damage type associated with your draconic ancestry." }
  },
  notes: "Dragonborn are humanoid dragons with breath weapons and damage resistance based on their draconic ancestry."
)

subrace_dragonborn = Subrace.create!(
  name: "Dragonborn",
  race: race_dragonborn,
  description: "Standard dragonborn with draconic heritage.",
  ability_modifiers: { "STR" => 2, "CHA" => 1 },
  traits: {
    "choose_ancestry" => { "description" => "Choose your draconic ancestry (Black, Blue, Brass, Bronze, Copper, Gold, Green, Red, Silver, White) which determines your breath weapon and damage resistance." }
  },
  notes: "Dragonborn gain strength and charisma, with abilities determined by their chosen dragon ancestry."
)

# === GNOME ===
race_gnome = Race.create!(
  name: "Gnome",
  description: "A gnome's energy and enthusiasm for living shines through every inch of his or her tiny body.",
  size: "Small",
  speed: 25,
  languages: ["Common", "Gnomish"],
  proficiencies: {},
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "gnome_cunning" => { "description" => "You have advantage on all Intelligence, Wisdom, and Charisma saving throws against magic." }
  },
  notes: "Gnomes are small, clever folk with darkvision and natural resistance to magic."
)

subrace_forest_gnome = Subrace.create!(
  name: "Forest Gnome",
  race: race_gnome,
  description: "Forest gnomes are rare and secretive, gathering in hidden communities in sylvan forests.",
  ability_modifiers: { "INT" => 2, "DEX" => 1 },
  traits: {
    "natural_illusionist" => { "description" => "You know the minor illusion cantrip. Intelligence is your spellcasting ability for it." },
    "speak_with_small_beasts" => { "description" => "Through sounds and gestures, you can communicate simple ideas with Small or smaller beasts." }
  },
  spells: ["minor_illusion"],
  notes: "Forest gnomes are dexterous and intelligent, with natural illusion magic and the ability to communicate with small animals."
)

subrace_rock_gnome = Subrace.create!(
  name: "Rock Gnome",
  race: race_gnome,
  description: "Rock gnomes are the most common variety of gnomes, known for their skill with devices and machinery.",
  ability_modifiers: { "INT" => 2, "CON" => 1 },
  proficiencies: {
    "tools" => ["tinker_tools"]
  },
  traits: {
    "artificers_lore" => { "description" => "Add twice your proficiency bonus to History checks related to magic items, alchemical objects, or technological devices." },
    "tinker" => { "description" => "You have proficiency with tinker's tools and can construct tiny clockwork devices." }
  },
  notes: "Rock gnomes are skilled inventors and tinkerers, with expertise in magical and technological devices."
)

# === HALF-ELF ===
race_half_elf = Race.create!(
  name: "Half-Elf",
  description: "Half-elves combine what some say are the best qualities of their elf and human parents.",
  size: "Medium",
  speed: 30,
  languages: ["Common", "Elvish"],
  proficiencies: {},
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "fey_ancestry" => { "description" => "You have advantage on saving throws against being charmed, and magic can't put you to sleep." },
    "skill_versatility" => { "description" => "You gain proficiency in two skills of your choice." }
  },
  notes: "Half-elves inherit the best of both worlds, combining human versatility with elven grace."
)

subrace_half_elf = Subrace.create!(
  name: "Half-Elf",
  race: race_half_elf,
  description: "Standard half-elf with mixed heritage.",
  ability_modifiers: { "CHA" => 2, "STR" => 1, "DEX" => 1 },
  proficiencies: {
    "skills" => ["two_skills_of_choice"]
  },
  languages: ["one_language_of_choice"],
  traits: {
    "versatile" => { "description" => "Choose two different ability scores to increase by 1 each." }
  },
  notes: "Half-elves are charismatic and versatile, able to choose additional ability score increases and skills."
)

# === HALF-ORC ===
race_half_orc = Race.create!(
  name: "Half-Orc",
  description: "Half-orcs most often live among orcs. Of the other races, humans are most likely to accept half-orcs.",
  size: "Medium",
  speed: 30,
  languages: ["Common", "Orc"],
  proficiencies: {},
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "relentless_endurance" => { "description" => "When you are reduced to 0 hit points but not killed outright, you can drop to 1 hit point instead. You can't use this feature again until you finish a long rest." },
    "savage_attacks" => { "description" => "When you score a critical hit with a melee weapon attack, you can roll one of the weapon's damage dice one additional time and add it to the extra damage." }
  },
  notes: "Half-orcs are strong and resilient, with the ability to fight beyond normal limits."
)

subrace_half_orc = Subrace.create!(
  name: "Half-Orc",
  race: race_half_orc,
  description: "Standard half-orc with orcish heritage.",
  ability_modifiers: { "STR" => 2, "CON" => 1 },
  proficiencies: {
    "skills" => ["Intimidation"]
  },
  traits: {
    "menacing" => { "description" => "You gain proficiency in the Intimidation skill." }
  },
  notes: "Half-orcs are strong and tough, with natural intimidation abilities inherited from their orcish heritage."
)

# === TIEFLING ===
race_tiefling = Race.create!(
  name: "Tiefling",
  description: "Tieflings are derived from human bloodlines, and in the broadest possible sense, they still look human.",
  size: "Medium",
  speed: 30,
  languages: ["Common", "Infernal"],
  proficiencies: {},
  traits: {
    "darkvision" => { "description" => "You can see in dim light within 60 feet as if it were bright light, and in darkness as if it were dim light.", "range" => 60 },
    "hellish_resistance" => { "description" => "You have resistance to fire damage." },
    "infernal_legacy" => { "description" => "You know the thaumaturgy cantrip. When you reach 3rd level, you can cast hellish rebuke once per long rest. When you reach 5th level, you can cast darkness once per long rest. Charisma is your spellcasting ability for these spells." }
  },
  notes: "Tieflings bear the mark of their infernal heritage, with fire resistance and innate magic."
)

subrace_tiefling = Subrace.create!(
  name: "Tiefling",
  race: race_tiefling,
  description: "Standard tiefling with infernal heritage.",
  ability_modifiers: { "INT" => 1, "CHA" => 2 },
  traits: {
    "infernal_legacy" => { "description" => "You know thaumaturgy. At 3rd level, you can cast hellish rebuke once per long rest. At 5th level, you can cast darkness once per long rest." }
  },
  spells: ["thaumaturgy"],
  notes: "Tieflings are intelligent and charismatic, with innate spellcasting abilities tied to their infernal heritage."
)

# === CLASSES & SUBCLASSES ===
# PHB Classes with comprehensive data mapping

# === BARBARIAN ===
class_barbarian = CharacterClass.create!(
  name: "Barbarian",
  description: "A fierce warrior of primitive background who can enter a battle rage.",
  hit_die: 12,
  primary_ability: ["Strength"],
  saving_throw_proficiencies: ["Strength", "Constitution"],
  skill_proficiencies: {
    "choose" => 2,
    "available" => ["Animal Handling", "Athletics", "Intimidation", "Nature", "Perception", "Survival"]
  },
  weapon_proficiencies: ["Simple weapons", "Martial weapons"],
  armor_proficiencies: ["Light armor", "Medium armor", "Shields"],
  tool_proficiencies: [],
  starting_equipment: {
    "weapon" => "Greataxe or any martial melee weapon",
    "ranged" => "Two handaxes or any simple weapon",
    "armor" => "Leather armor",
    "pack" => "Explorer's pack",
    "other" => "Four javelins"
  },
  spellcasting: {},
  class_features: {
    "1" => { "rage" => true, "unarmored_defense" => true },
    "2" => { "reckless_attack" => true, "danger_sense" => true },
    "3" => { "primal_path" => true },
    "4" => { "ability_score_improvement" => true },
    "5" => { "extra_attack" => true, "fast_movement" => true },
    "6" => { "path_feature" => true },
    "7" => { "feral_instinct" => true },
    "8" => { "ability_score_improvement" => true },
    "9" => { "brutal_critical_1" => true },
    "10" => { "path_feature" => true },
    "11" => { "relentless_rage" => true },
    "12" => { "ability_score_improvement" => true },
    "13" => { "brutal_critical_2" => true },
    "14" => { "path_feature" => true },
    "15" => { "persistent_rage" => true },
    "16" => { "ability_score_improvement" => true },
    "17" => { "brutal_critical_3" => true },
    "18" => { "indomitable_might" => true },
    "19" => { "ability_score_improvement" => true },
    "20" => { "primal_champion" => true }
  },
  multiclass_requirements: { "Strength" => 13 },
  ability_requirements: {},
  bonuses: {},
  notes: "Barbarians are defined by their rage, a ferocity that gives them uncanny powers and resistance to harm."
)

subclass_berserker = Subclass.create!(
  name: "Path of the Berserker",
  character_class: class_barbarian,
  description: "For some barbarians, rage is a means to an end—that end being violence. The Path of the Berserker is a path of untrammeled fury, slick with blood.",
  subclass_features: {
    "3" => { "frenzy" => true },
    "6" => { "mindless_rage" => true },
    "10" => { "intimidating_presence" => true },
    "14" => { "retaliation" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: { "rage_bonus" => true },
  notes: "Berserkers can enter a frenzy during rage, making additional attacks but gaining exhaustion."
)

subclass_totem = Subclass.create!(
  name: "Path of the Totem Warrior",
  character_class: class_barbarian,
  description: "The Path of the Totem Warrior is a spiritual journey, as the barbarian accepts a spirit animal as guide, protector, and inspiration.",
  subclass_features: {
    "3" => { "spirit_seeker" => true, "totem_spirit" => true },
    "6" => { "aspect_of_the_beast" => true },
    "10" => { "spirit_walker" => true },
    "14" => { "totemic_attunement" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: { "animal_spirit" => true },
  notes: "Totem Warriors gain abilities based on spirit animals: Bear (resistance), Eagle (sight), or Wolf (pack tactics)."
)

# === FIGHTER ===
class_fighter = CharacterClass.create!(
  name: "Fighter",
  description: "A master of martial combat, skilled with a variety of weapons and armor.",
  hit_die: 10,
  primary_ability: ["Strength", "Dexterity"],
  saving_throw_proficiencies: ["Strength", "Constitution"],
  skill_proficiencies: {
    "choose" => 2,
    "available" => ["Acrobatics", "Animal Handling", "Athletics", "History", "Insight", "Intimidation", "Perception", "Survival"]
  },
  weapon_proficiencies: ["Simple weapons", "Martial weapons"],
  armor_proficiencies: ["Light armor", "Medium armor", "Heavy armor", "Shields"],
  tool_proficiencies: [],
  starting_equipment: {
    "armor" => "Chain mail or leather armor",
    "shield" => "Shield or second weapon",
    "weapon" => "Martial weapon and shield or two martial weapons",
    "ranged" => "Light crossbow and 20 bolts or two handaxes",
    "pack" => "Dungeoneer's pack or explorer's pack"
  },
  spellcasting: {},
  class_features: {
    "1" => { "fighting_style" => true, "second_wind" => true },
    "2" => { "action_surge" => true },
    "3" => { "martial_archetype" => true },
    "4" => { "ability_score_improvement" => true },
    "5" => { "extra_attack" => true },
    "6" => { "ability_score_improvement" => true },
    "7" => { "martial_archetype_feature" => true },
    "8" => { "ability_score_improvement" => true },
    "9" => { "indomitable" => true },
    "10" => { "martial_archetype_feature" => true },
    "11" => { "extra_attack_2" => true },
    "12" => { "ability_score_improvement" => true },
    "13" => { "indomitable_2" => true },
    "14" => { "ability_score_improvement" => true },
    "15" => { "martial_archetype_feature" => true },
    "16" => { "ability_score_improvement" => true },
    "17" => { "action_surge_2" => true, "indomitable_3" => true },
    "18" => { "martial_archetype_feature" => true },
    "19" => { "ability_score_improvement" => true },
    "20" => { "extra_attack_3" => true }
  },
  multiclass_requirements: { "Strength" => 13, "Dexterity" => 13 },
  ability_requirements: {},
  bonuses: {},
  notes: "Fighters are the most versatile combatants, able to specialize in many different fighting styles and tactics."
)

subclass_champion = Subclass.create!(
  name: "Champion",
  character_class: class_fighter,
  description: "The archetypal Champion focuses on the development of raw physical power honed to deadly perfection.",
  subclass_features: {
    "3" => { "improved_critical" => true },
    "7" => { "remarkable_athlete" => true },
    "10" => { "additional_fighting_style" => true },
    "15" => { "superior_critical" => true },
    "18" => { "survivor" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: { "extra_attack" => true },
  notes: "Champions focus on improving their physical abilities and critical hit chances."
)

subclass_battlemaster = Subclass.create!(
  name: "Battle Master",
  character_class: class_fighter,
  description: "Those who emulate the archetypal Battle Master employ martial techniques passed down through generations.",
  subclass_features: {
    "3" => { "combat_superiority" => true, "maneuvers" => true },
    "7" => { "know_your_enemy" => true },
    "10" => { "improved_combat_superiority" => true },
    "15" => { "relentless" => true },
    "18" => { "combat_superiority_master" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: { "combat_superiority" => true },
  notes: "Battle Masters use superiority dice to fuel special maneuvers that enhance their combat effectiveness."
)

# === ROGUE ===
class_rogue = CharacterClass.create!(
  name: "Rogue",
  description: "A scoundrel who uses stealth and trickery to accomplish what others can't.",
  hit_die: 8,
  primary_ability: ["Dexterity"],
  saving_throw_proficiencies: ["Dexterity", "Intelligence"],
  skill_proficiencies: {
    "choose" => 4,
    "available" => ["Acrobatics", "Athletics", "Deception", "Insight", "Intimidation", "Investigation", "Perception", "Performance", "Persuasion", "Sleight of Hand", "Stealth"]
  },
  weapon_proficiencies: ["Simple weapons", "Hand crossbows", "Longswords", "Rapiers", "Shortswords"],
  armor_proficiencies: ["Light armor"],
  tool_proficiencies: ["Thieves' tools"],
  starting_equipment: {
    "weapon" => "Rapier or shortsword",
    "ranged" => "Shortbow and quiver of 20 arrows",
    "armor" => "Leather armor",
    "pack" => "Burglar's pack",
    "other" => "Two daggers, thieves' tools"
  },
  spellcasting: {},
  class_features: {
    "1" => { "expertise" => true, "sneak_attack" => true, "thieves_cant" => true },
    "2" => { "cunning_action" => true },
    "3" => { "roguish_archetype" => true },
    "4" => { "ability_score_improvement" => true },
    "5" => { "uncanny_dodge" => true },
    "6" => { "expertise" => true },
    "7" => { "evasion" => true },
    "8" => { "ability_score_improvement" => true },
    "9" => { "roguish_archetype_feature" => true },
    "10" => { "ability_score_improvement" => true },
    "11" => { "reliable_talent" => true },
    "12" => { "ability_score_improvement" => true },
    "13" => { "roguish_archetype_feature" => true },
    "14" => { "blindsense" => true },
    "15" => { "slippery_mind" => true },
    "16" => { "ability_score_improvement" => true },
    "17" => { "roguish_archetype_feature" => true },
    "18" => { "elusive" => true },
    "19" => { "ability_score_improvement" => true },
    "20" => { "stroke_of_luck" => true }
  },
  multiclass_requirements: { "Dexterity" => 13 },
  ability_requirements: {},
  bonuses: {},
  notes: "Rogues rely on skill, stealth, and their foes' vulnerabilities to get the upper hand in any situation."
)

subclass_thief = Subclass.create!(
  name: "Thief",
  character_class: class_rogue,
  description: "You hone your skills in the larcenous arts. Burglars, bandits, cutpurses, and other criminals typically follow this archetype.",
  subclass_features: {
    "3" => { "fast_hands" => true, "second_story_work" => true },
    "9" => { "supreme_sneak" => true },
    "13" => { "use_magic_device" => true },
    "17" => { "thiefs_reflexes" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: { "fast_hands" => true },
  notes: "Thieves are skilled at breaking and entering, pickpocketing, and other forms of larceny."
)

subclass_assassin = Subclass.create!(
  name: "Assassin",
  character_class: class_rogue,
  description: "You focus your training on the grim art of death. Those who adhere to this archetype are diverse.",
  subclass_features: {
    "3" => { "bonus_proficiencies" => true, "assassinate" => true },
    "9" => { "infiltration_expertise" => true },
    "13" => { "impostor" => true },
    "17" => { "death_strike" => true }
  },
  spells: [],
  proficiencies: {
    "tools" => ["Disguise kit", "Poisoner's kit"]
  },
  bonuses: { "sneak_attack" => true },
  notes: "Assassins are skilled at elimination, infiltration, and disguise."
)

# === WIZARD ===
class_wizard = CharacterClass.create!(
  name: "Wizard",
  description: "A scholarly magic-user capable of manipulating the structures of reality.",
  hit_die: 6,
  primary_ability: ["Intelligence"],
  saving_throw_proficiencies: ["Intelligence", "Wisdom"],
  skill_proficiencies: {
    "choose" => 2,
    "available" => ["Arcana", "History", "Insight", "Investigation", "Medicine", "Religion"]
  },
  weapon_proficiencies: ["Daggers", "Darts", "Slings", "Quarterstaffs", "Light crossbows"],
  armor_proficiencies: [],
  tool_proficiencies: [],
  starting_equipment: {
    "weapon" => "Quarterstaff or dagger",
    "ranged" => "Light crossbow and 20 bolts or any simple weapon",
    "armor" => "None",
    "pack" => "Scholar's pack",
    "other" => "Spellbook, component pouch"
  },
  spellcasting: {
    "ability" => "Intelligence",
    "ritual_casting" => true,
    "spellcasting_focus" => "Arcane focus",
    "spells_known" => "Spellbook",
    "cantrips_known" => { "1" => 3, "4" => 4, "10" => 5 }
  },
  class_features: {
    "1" => { "spellcasting" => true, "arcane_recovery" => true },
    "2" => { "arcane_tradition" => true },
    "4" => { "ability_score_improvement" => true },
    "6" => { "arcane_tradition_feature" => true },
    "8" => { "ability_score_improvement" => true },
    "10" => { "arcane_tradition_feature" => true },
    "12" => { "ability_score_improvement" => true },
    "14" => { "arcane_tradition_feature" => true },
    "16" => { "ability_score_improvement" => true },
    "18" => { "spell_mastery" => true },
    "19" => { "ability_score_improvement" => true },
    "20" => { "signature_spells" => true }
  },
  multiclass_requirements: { "Intelligence" => 13 },
  ability_requirements: {},
  bonuses: {},
  notes: "Wizards are supreme magic-users, defined by their spellcasting ability and vast knowledge of arcane lore."
)

subclass_evocation = Subclass.create!(
  name: "School of Evocation",
  character_class: class_wizard,
  description: "You focus your study on magic that creates powerful elemental effects such as bitter cold, searing flame, rolling thunder, crackling lightning, and burning acid.",
  subclass_features: {
    "2" => { "evocation_savant" => true, "sculpt_spells" => true },
    "6" => { "potent_cantrip" => true },
    "10" => { "empowered_evocation" => true },
    "14" => { "overchannel" => true }
  },
  spells: [],
  proficiencies: {},
  bonuses: {},
  notes: "Evocation wizards specialize in destructive magic, learning to sculpt their spells to avoid harming allies."
)

# === CLERIC ===
class_cleric = CharacterClass.create!(
  name: "Cleric",
  description: "A priestly champion who wields divine magic in service of a higher power.",
  hit_die: 8,
  primary_ability: ["Wisdom"],
  saving_throw_proficiencies: ["Wisdom", "Charisma"],
  skill_proficiencies: {
    "choose" => 2,
    "available" => ["History", "Insight", "Medicine", "Persuasion", "Religion"]
  },
  weapon_proficiencies: ["Simple weapons"],
  armor_proficiencies: ["Light armor", "Medium armor", "Shields"],
  tool_proficiencies: [],
  starting_equipment: {
    "weapon" => "Mace or warhammer",
    "armor" => "Scale mail or leather armor",
    "shield" => "Shield",
    "ranged" => "Light crossbow and 20 bolts or any simple weapon",
    "pack" => "Priest's pack",
    "other" => "Holy symbol"
  },
  spellcasting: {
    "ability" => "Wisdom",
    "ritual_casting" => true,
    "spellcasting_focus" => "Holy symbol",
    "spells_known" => "All cleric spells",
    "cantrips_known" => { "1" => 3, "4" => 4, "10" => 5 }
  },
  class_features: {
    "1" => { "spellcasting" => true, "divine_domain" => true },
    "2" => { "channel_divinity" => true, "divine_domain_feature" => true },
    "4" => { "ability_score_improvement" => true },
    "5" => { "destroy_undead" => true },
    "6" => { "channel_divinity_2" => true, "divine_domain_feature" => true },
    "8" => { "ability_score_improvement" => true, "divine_domain_feature" => true },
    "10" => { "divine_intervention" => true },
    "12" => { "ability_score_improvement" => true },
    "14" => { "destroy_undead_improvement" => true },
    "16" => { "ability_score_improvement" => true },
    "17" => { "divine_domain_feature" => true },
    "18" => { "channel_divinity_3" => true },
    "19" => { "ability_score_improvement" => true },
    "20" => { "divine_intervention_improvement" => true }
  },
  multiclass_requirements: { "Wisdom" => 13 },
  ability_requirements: {},
  bonuses: {},
  notes: "Clerics are intermediaries between the mortal world and the distant planes of the gods."
)

# === ITEMS ===
# PHB Weapons and Armor with complete data mapping

# === SIMPLE MELEE WEAPONS ===
simple_melee_weapons = [
  {
    name: "Club",
    item_type: "weapon",
    description: "A simple wooden club.",
    rarity: "common",
    cost_gp: 0.1,
    weight_lbs: 2,
    damage_dice: "1d4",
    damage_type: "bludgeoning",
    weapon_type: "simple",
    weapon_category: "melee",
    weapon_properties: { "light" => true },
    notes: "Basic bludgeoning weapon, can be found or improvised"
  },
  {
    name: "Dagger",
    item_type: "weapon",
    description: "A sharp, pointed blade.",
    rarity: "common",
    cost_gp: 2,
    weight_lbs: 1,
    damage_dice: "1d4",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "melee",
    range_normal: 20,
    range_long: 60,
    weapon_properties: { "finesse" => true, "light" => true, "thrown" => true },
    notes: "Versatile melee/ranged weapon, uses DEX for attacks"
  },
  {
    name: "Dart",
    item_type: "weapon",
    description: "A small throwing weapon.",
    rarity: "common",
    cost_gp: 0.05,
    weight_lbs: 0.25,
    damage_dice: "1d4",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "ranged",
    range_normal: 20,
    range_long: 60,
    weapon_properties: { "finesse" => true, "thrown" => true },
    notes: "Light ranged weapon, uses DEX for attacks"
  },
  {
    name: "Javelin",
    item_type: "weapon",
    description: "A light spear designed for throwing.",
    rarity: "common",
    cost_gp: 0.5,
    weight_lbs: 2,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "melee",
    range_normal: 30,
    range_long: 120,
    weapon_properties: { "thrown" => true },
    notes: "Can be used in melee or thrown"
  },
  {
    name: "Light Hammer",
    item_type: "weapon",
    description: "A small hammer suitable for throwing.",
    rarity: "common",
    cost_gp: 2,
    weight_lbs: 2,
    damage_dice: "1d4",
    damage_type: "bludgeoning",
    weapon_type: "simple",
    weapon_category: "melee",
    range_normal: 20,
    range_long: 60,
    weapon_properties: { "light" => true, "thrown" => true },
    notes: "Light melee weapon that can be thrown"
  },
  {
    name: "Mace",
    item_type: "weapon",
    description: "A heavy club with a spiked or flanged head.",
    rarity: "common",
    cost_gp: 5,
    weight_lbs: 4,
    damage_dice: "1d6",
    damage_type: "bludgeoning",
    weapon_type: "simple",
    weapon_category: "melee",
    notes: "Standard simple melee weapon"
  },
  {
    name: "Quarterstaff",
    item_type: "weapon",
    description: "A long wooden staff.",
    rarity: "common",
    cost_gp: 0.2,
    weight_lbs: 4,
    damage_dice: "1d6",
    damage_type: "bludgeoning",
    weapon_type: "simple",
    weapon_category: "melee",
    weapon_properties: { "versatile" => "1d8" },
    notes: "Can be used one-handed (1d6) or two-handed (1d8)"
  },
  {
    name: "Sickle",
    item_type: "weapon",
    description: "A curved blade on a short handle.",
    rarity: "common",
    cost_gp: 1,
    weight_lbs: 2,
    damage_dice: "1d4",
    damage_type: "slashing",
    weapon_type: "simple",
    weapon_category: "melee",
    weapon_properties: { "light" => true },
    notes: "Light slashing weapon"
  },
  {
    name: "Spear",
    item_type: "weapon",
    description: "A long shaft with a pointed tip.",
    rarity: "common",
    cost_gp: 1,
    weight_lbs: 3,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "melee",
    range_normal: 20,
    range_long: 60,
    weapon_properties: { "thrown" => true, "versatile" => "1d8" },
    notes: "Can be used one-handed (1d6) or two-handed (1d8), throwable"
  }
]

# === SIMPLE RANGED WEAPONS ===
simple_ranged_weapons = [
  {
    name: "Light Crossbow",
    item_type: "weapon",
    description: "A compact crossbow.",
    rarity: "common",
    cost_gp: 25,
    weight_lbs: 5,
    damage_dice: "1d8",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "ranged",
    range_normal: 80,
    range_long: 320,
    weapon_properties: { "ammunition" => true, "loading" => true, "two_handed" => true },
    notes: "Requires bolts, loading property limits to one shot per turn"
  },
  {
    name: "Shortbow",
    item_type: "weapon",
    description: "A compact bow.",
    rarity: "common",
    cost_gp: 25,
    weight_lbs: 2,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "simple",
    weapon_category: "ranged",
    range_normal: 80,
    range_long: 320,
    weapon_properties: { "ammunition" => true, "two_handed" => true },
    notes: "Requires arrows, two-handed weapon"
  },
  {
    name: "Sling",
    item_type: "weapon",
    description: "A leather pouch for launching stones.",
    rarity: "common",
    cost_gp: 0.1,
    weight_lbs: 0,
    damage_dice: "1d4",
    damage_type: "bludgeoning",
    weapon_type: "simple",
    weapon_category: "ranged",
    range_normal: 30,
    range_long: 120,
    weapon_properties: { "ammunition" => true },
    notes: "Requires sling bullets or stones"
  }
]

# === MARTIAL MELEE WEAPONS ===
martial_melee_weapons = [
  {
    name: "Battleaxe",
    item_type: "weapon",
    description: "A heavy axe with a broad blade.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 4,
    damage_dice: "1d8",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "versatile" => "1d10" },
    notes: "Can be used one-handed (1d8) or two-handed (1d10)"
  },
  {
    name: "Flail",
    item_type: "weapon",
    description: "A spiked ball on a chain.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 2,
    damage_dice: "1d8",
    damage_type: "bludgeoning",
    weapon_type: "martial",
    weapon_category: "melee",
    notes: "Martial one-handed weapon"
  },
  {
    name: "Glaive",
    item_type: "weapon",
    description: "A blade on the end of a long pole.",
    rarity: "common",
    cost_gp: 20,
    weight_lbs: 6,
    damage_dice: "1d10",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "reach" => true, "two_handed" => true },
    notes: "Two-handed polearm with reach"
  },
  {
    name: "Greataxe",
    item_type: "weapon",
    description: "A massive two-handed axe.",
    rarity: "common",
    cost_gp: 30,
    weight_lbs: 7,
    damage_dice: "1d12",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "two_handed" => true },
    notes: "Two-handed weapon with highest damage die"
  },
  {
    name: "Greatsword",
    item_type: "weapon",
    description: "A massive two-handed sword.",
    rarity: "common",
    cost_gp: 50,
    weight_lbs: 6,
    damage_dice: "2d6",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "two_handed" => true },
    notes: "Two-handed weapon with consistent damage"
  },
  {
    name: "Halberd",
    item_type: "weapon",
    description: "An axe blade topped with a spike.",
    rarity: "common",
    cost_gp: 20,
    weight_lbs: 6,
    damage_dice: "1d10",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "reach" => true, "two_handed" => true },
    notes: "Two-handed polearm with reach"
  },
  {
    name: "Lance",
    item_type: "weapon",
    description: "A long spear designed for mounted combat.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 6,
    damage_dice: "1d12",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "reach" => true, "special" => true },
    notes: "Disadvantage when used against targets within 5 feet"
  },
  {
    name: "Longsword",
    item_type: "weapon",
    description: "A well-balanced sword.",
    rarity: "common",
    cost_gp: 15,
    weight_lbs: 3,
    damage_dice: "1d8",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "versatile" => "1d10" },
    notes: "Can be used one-handed (1d8) or two-handed (1d10)"
  },
  {
    name: "Maul",
    item_type: "weapon",
    description: "A heavy two-handed hammer.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 10,
    damage_dice: "2d6",
    damage_type: "bludgeoning",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "two_handed" => true },
    notes: "Two-handed bludgeoning weapon"
  },
  {
    name: "Morningstar",
    item_type: "weapon",
    description: "A spiked mace.",
    rarity: "common",
    cost_gp: 15,
    weight_lbs: 4,
    damage_dice: "1d8",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    notes: "One-handed martial weapon"
  },
  {
    name: "Pike",
    item_type: "weapon",
    description: "A very long spear.",
    rarity: "common",
    cost_gp: 5,
    weight_lbs: 18,
    damage_dice: "1d10",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "heavy" => true, "reach" => true, "two_handed" => true },
    notes: "Longest reach weapon"
  },
  {
    name: "Rapier",
    item_type: "weapon",
    description: "A slender, sharply pointed sword.",
    rarity: "common",
    cost_gp: 25,
    weight_lbs: 2,
    damage_dice: "1d8",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "finesse" => true },
    notes: "Finesse weapon, uses DEX for attacks"
  },
  {
    name: "Scimitar",
    item_type: "weapon",
    description: "A curved sword.",
    rarity: "common",
    cost_gp: 25,
    weight_lbs: 3,
    damage_dice: "1d6",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "finesse" => true, "light" => true },
    notes: "Finesse and light weapon, good for dual wielding"
  },
  {
    name: "Shortsword",
    item_type: "weapon",
    description: "A short, light sword.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 2,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "finesse" => true, "light" => true },
    notes: "Finesse and light weapon, good for dual wielding"
  },
  {
    name: "Trident",
    item_type: "weapon",
    description: "A three-pronged spear.",
    rarity: "common",
    cost_gp: 5,
    weight_lbs: 4,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    range_normal: 20,
    range_long: 60,
    weapon_properties: { "thrown" => true, "versatile" => "1d8" },
    notes: "Can be used one-handed (1d6) or two-handed (1d8), throwable"
  },
  {
    name: "War Pick",
    item_type: "weapon",
    description: "A pick with a long spike.",
    rarity: "common",
    cost_gp: 5,
    weight_lbs: 2,
    damage_dice: "1d8",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "melee",
    notes: "One-handed martial weapon"
  },
  {
    name: "Warhammer",
    item_type: "weapon",
    description: "A heavy hammer designed for combat.",
    rarity: "common",
    cost_gp: 15,
    weight_lbs: 2,
    damage_dice: "1d8",
    damage_type: "bludgeoning",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "versatile" => "1d10" },
    notes: "Can be used one-handed (1d8) or two-handed (1d10)"
  },
  {
    name: "Whip",
    item_type: "weapon",
    description: "A flexible leather weapon.",
    rarity: "common",
    cost_gp: 2,
    weight_lbs: 3,
    damage_dice: "1d4",
    damage_type: "slashing",
    weapon_type: "martial",
    weapon_category: "melee",
    weapon_properties: { "finesse" => true, "reach" => true },
    notes: "Finesse weapon with reach"
  }
]

# === MARTIAL RANGED WEAPONS ===
martial_ranged_weapons = [
  {
    name: "Blowgun",
    item_type: "weapon",
    description: "A tube for firing darts.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 1,
    damage_dice: "1",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "ranged",
    range_normal: 25,
    range_long: 100,
    weapon_properties: { "ammunition" => true, "loading" => true },
    notes: "Often used with poison, minimal damage"
  },
  {
    name: "Hand Crossbow",
    item_type: "weapon",
    description: "A small crossbow fired with one hand.",
    rarity: "common",
    cost_gp: 75,
    weight_lbs: 3,
    damage_dice: "1d6",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "ranged",
    range_normal: 30,
    range_long: 120,
    weapon_properties: { "ammunition" => true, "light" => true, "loading" => true },
    notes: "One-handed crossbow, good for dual wielding"
  },
  {
    name: "Heavy Crossbow",
    item_type: "weapon",
    description: "A large, powerful crossbow.",
    rarity: "common",
    cost_gp: 50,
    weight_lbs: 18,
    damage_dice: "1d10",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "ranged",
    range_normal: 100,
    range_long: 400,
    weapon_properties: { "ammunition" => true, "heavy" => true, "loading" => true, "two_handed" => true },
    notes: "Powerful ranged weapon, loading limits shots"
  },
  {
    name: "Longbow",
    item_type: "weapon",
    description: "A tall bow with great range.",
    rarity: "common",
    cost_gp: 50,
    weight_lbs: 2,
    damage_dice: "1d8",
    damage_type: "piercing",
    weapon_type: "martial",
    weapon_category: "ranged",
    range_normal: 150,
    range_long: 600,
    weapon_properties: { "ammunition" => true, "heavy" => true, "two_handed" => true },
    notes: "Longest range weapon in PHB"
  },
  {
    name: "Net",
    item_type: "weapon",
    description: "A weighted net for entangling foes.",
    rarity: "common",
    cost_gp: 1,
    weight_lbs: 3,
    damage_dice: "0",
    damage_type: "none",
    weapon_type: "martial",
    weapon_category: "ranged",
    range_normal: 5,
    range_long: 15,
    weapon_properties: { "special" => true, "thrown" => true },
    notes: "Restrains target on hit, no damage"
  }
]

# === LIGHT ARMOR ===
light_armor = [
  {
    name: "Padded",
    item_type: "armor",
    description: "Layers of cloth and batting.",
    rarity: "common",
    cost_gp: 5,
    weight_lbs: 8,
    armor_class: 11,
    armor_type: "light",
    max_dex_bonus: nil,
    stealth_disadvantage: true,
    notes: "Cheapest armor, but gives stealth disadvantage"
  },
  {
    name: "Leather",
    item_type: "armor",
    description: "Soft and flexible leather.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 10,
    armor_class: 11,
    armor_type: "light",
    max_dex_bonus: nil,
    notes: "Standard light armor"
  },
  {
    name: "Studded Leather",
    item_type: "armor",
    description: "Leather reinforced with metal studs.",
    rarity: "common",
    cost_gp: 45,
    weight_lbs: 13,
    armor_class: 12,
    armor_type: "light",
    max_dex_bonus: nil,
    notes: "Best light armor in PHB"
  }
]

# === MEDIUM ARMOR ===
medium_armor = [
  {
    name: "Hide",
    item_type: "armor",
    description: "Crude armor made from thick furs and pelts.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 12,
    armor_class: 12,
    armor_type: "medium",
    max_dex_bonus: 2,
    notes: "Basic medium armor"
  },
  {
    name: "Chain Shirt",
    item_type: "armor",
    description: "A shirt of interlocking metal rings.",
    rarity: "common",
    cost_gp: 50,
    weight_lbs: 20,
    armor_class: 13,
    armor_type: "medium",
    max_dex_bonus: 2,
    notes: "Light chain armor"
  },
  {
    name: "Scale Mail",
    item_type: "armor",
    description: "Leather armor with overlapping metal scales.",
    rarity: "common",
    cost_gp: 50,
    weight_lbs: 45,
    armor_class: 14,
    armor_type: "medium",
    max_dex_bonus: 2,
    stealth_disadvantage: true,
    notes: "Medium armor with stealth disadvantage"
  },
  {
    name: "Breastplate",
    item_type: "armor",
    description: "A fitted metal chest piece.",
    rarity: "common",
    cost_gp: 400,
    weight_lbs: 20,
    armor_class: 14,
    armor_type: "medium",
    max_dex_bonus: 2,
    notes: "No stealth disadvantage for medium armor"
  },
  {
    name: "Half Plate",
    item_type: "armor",
    description: "Plate armor covering the torso, arms, and legs.",
    rarity: "common",
    cost_gp: 750,
    weight_lbs: 40,
    armor_class: 15,
    armor_type: "medium",
    max_dex_bonus: 2,
    stealth_disadvantage: true,
    notes: "Best medium armor, but with stealth disadvantage"
  }
]

# === HEAVY ARMOR ===
heavy_armor = [
  {
    name: "Ring Mail",
    item_type: "armor",
    description: "Leather armor with heavy rings sewn into it.",
    rarity: "common",
    cost_gp: 30,
    weight_lbs: 40,
    armor_class: 14,
    armor_type: "heavy",
    max_dex_bonus: 0,
    stealth_disadvantage: true,
    notes: "Weakest heavy armor"
  },
  {
    name: "Chain Mail",
    item_type: "armor",
    description: "Interlocking metal rings.",
    rarity: "common",
    cost_gp: 75,
    weight_lbs: 55,
    armor_class: 16,
    armor_type: "heavy",
    max_dex_bonus: 0,
    strength_requirement: 13,
    stealth_disadvantage: true,
    notes: "Requires 13 Strength"
  },
  {
    name: "Splint",
    item_type: "armor",
    description: "Metal strips over leather backing.",
    rarity: "common",
    cost_gp: 200,
    weight_lbs: 60,
    armor_class: 17,
    armor_type: "heavy",
    max_dex_bonus: 0,
    strength_requirement: 15,
    stealth_disadvantage: true,
    notes: "Requires 15 Strength"
  },
  {
    name: "Plate",
    item_type: "armor",
    description: "Interlocking metal plates.",
    rarity: "common",
    cost_gp: 1500,
    weight_lbs: 65,
    armor_class: 18,
    armor_type: "heavy",
    max_dex_bonus: 0,
    strength_requirement: 15,
    stealth_disadvantage: true,
    notes: "Best armor in PHB, requires 15 Strength"
  }
]

# === SHIELDS ===
shields = [
  {
    name: "Shield",
    item_type: "shield",
    description: "A protective barrier held in the hand.",
    rarity: "common",
    cost_gp: 10,
    weight_lbs: 6,
    armor_class: 2,
    armor_type: "shield",
    notes: "Provides +2 AC bonus, requires free hand"
  }
]

# === ADVENTURING GEAR (SAMPLE) ===
adventuring_gear = [
  {
    name: "Backpack",
    item_type: "adventuring_gear",
    description: "A leather pack for carrying gear.",
    rarity: "common",
    cost_gp: 2,
    weight_lbs: 5,
    notes: "Can hold 30 lbs of gear"
  },
  {
    name: "Bedroll",
    item_type: "adventuring_gear",
    description: "A blanket and pad for sleeping.",
    rarity: "common",
    cost_gp: 0.5,
    weight_lbs: 7,
    notes: "Provides comfort while resting"
  },
  {
    name: "Rope (50 feet)",
    item_type: "adventuring_gear",
    description: "Hemp rope.",
    rarity: "common",
    cost_gp: 1,
    weight_lbs: 10,
    notes: "Essential for climbing and binding"
  },
  {
    name: "Torch",
    item_type: "adventuring_gear",
    description: "A stick with a combustible tip.",
    rarity: "common",
    cost_gp: 0.01,
    weight_lbs: 1,
    notes: "Provides light for 1 hour"
  },
  {
    name: "Rations (1 day)",
    item_type: "consumable",
    description: "Dried foods for sustenance.",
    rarity: "common",
    cost_gp: 0.5,
    weight_lbs: 2,
    notes: "Prevents starvation for one day"
  },
  {
    name: "Waterskin",
    item_type: "adventuring_gear",
    description: "A leather container for water.",
    rarity: "common",
    cost_gp: 0.5,
    weight_lbs: 5,
    notes: "Holds 4 pints of liquid"
  }
]

# Create all items
all_items = simple_melee_weapons + simple_ranged_weapons + martial_melee_weapons +
            martial_ranged_weapons + light_armor + medium_armor + heavy_armor + shields + adventuring_gear

item_records = all_items.map { |item_data| Item.create!(item_data) }

# === USERS & CHARACTERS ===

# User 1
user1 = User.create!(first_name: "Ayla", last_name: "Rivers", email: "ayla@example.com")

char1 = Character.create!(name: "Thorne", user: user1, race: race_human, subrace: subrace_variant_human, character_class: class_barbarian, subclass: subclass_totem, level: 1, movement_speed: 30, max_hp: 12, visibility_range: 60)
char2 = Character.create!(name: "Nim", user: user1, race: race_elf, subrace: subrace_high_elf, character_class: class_rogue, subclass: subclass_assassin, level: 1, movement_speed: 30, max_hp: 8, visibility_range: 60)
char3 = Character.create!(name: "Durgan", user: user1, race: race_dwarf, subrace: subrace_mountain_dwarf, character_class: class_fighter, subclass: subclass_battlemaster, level: 1, movement_speed: 25, max_hp: 10, visibility_range: 60)
char4 = Character.create!(name: "Sera", user: user1, race: race_elf, subrace: subrace_wood_elf, character_class: class_rogue, subclass: subclass_thief, level: 1, movement_speed: 30, max_hp: 8, visibility_range: 60)
char5 = Character.create!(name: "Bram", user: user1, race: race_human, subrace: subrace_standard_human, character_class: class_fighter, subclass: subclass_champion, level: 1, movement_speed: 30, max_hp: 10, visibility_range: 60)

# User 2
user2 = User.create!(first_name: "Kellen", last_name: "Voss", email: "kellen@example.com")

char6 = Character.create!(name: "Kael", user: user2, race: race_elf, subrace: subrace_high_elf, character_class: class_fighter, subclass: subclass_battlemaster, level: 1, movement_speed: 30, max_hp: 10, visibility_range: 60)
char7 = Character.create!(name: "Lira", user: user2, race: race_dwarf, subrace: subrace_hill_dwarf, character_class: class_barbarian, subclass: subclass_berserker, level: 1, movement_speed: 25, max_hp: 12, visibility_range: 60)
char8 = Character.create!(name: "Tovin", user: user2, race: race_human, subrace: subrace_variant_human, character_class: class_rogue, subclass: subclass_thief, level: 1, movement_speed: 30, max_hp: 8, visibility_range: 60)
char9 = Character.create!(name: "Runa", user: user2, race: race_elf, subrace: subrace_wood_elf, character_class: class_rogue, subclass: subclass_assassin, level: 1, movement_speed: 30, max_hp: 8, visibility_range: 60)
char10 = Character.create!(name: "Brek", user: user2, race: race_dwarf, subrace: subrace_mountain_dwarf, character_class: class_barbarian, subclass: subclass_totem, level: 1, movement_speed: 25, max_hp: 12, visibility_range: 60)

# User 3
user3 = User.create!(first_name: "Mira", last_name: "Dalca", email: "mira@example.com")

char11 = Character.create!(name: "Finn", user: user3, race: race_human, subrace: subrace_standard_human, character_class: class_fighter, subclass: subclass_champion, level: 1, movement_speed: 30, max_hp: 10, visibility_range: 60)
char12 = Character.create!(name: "Vex", user: user3, race: race_elf, subrace: subrace_high_elf, character_class: class_rogue, subclass: subclass_assassin, level: 1, movement_speed: 30, max_hp: 8, visibility_range: 60)
char13 = Character.create!(name: "Orla", user: user3, race: race_dwarf, subrace: subrace_hill_dwarf, character_class: class_barbarian, subclass: subclass_berserker, level: 1, movement_speed: 25, max_hp: 12, visibility_range: 60)
char14 = Character.create!(name: "Thia", user: user3, race: race_elf, subrace: subrace_wood_elf, character_class: class_fighter, subclass: subclass_battlemaster, level: 1, movement_speed: 30, max_hp: 10, visibility_range: 60)
char15 = Character.create!(name: "Jarek", user: user3, race: race_human, subrace: subrace_variant_human, character_class: class_barbarian, subclass: subclass_totem, level: 1, movement_speed: 30, max_hp: 12, visibility_range: 60)

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

# Set ability scores for all characters
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

# === ASSIGN ITEMS TO CHARACTERS ===
# Assign appropriate weapons and armor to each character based on their class
[char1, char2, char3, char4, char5, char6, char7, char8, char9, char10, char11, char12, char13, char14, char15].each do |char|
  # Give each character a weapon appropriate to their class
  weapon = case char.character_class.name
           when "Barbarian"
             item_records.find { |item| item.name == "Greataxe" } || item_records.find { |item| item.weapon? }
           when "Fighter"
             item_records.find { |item| item.name == "Longsword" } || item_records.find { |item| item.weapon? }
           when "Rogue"
             item_records.find { |item| item.name == "Shortsword" } || item_records.find { |item| item.weapon? }
           else
             item_records.find { |item| item.weapon? }
           end

  # Give each character basic armor
  armor = case char.character_class.name
          when "Barbarian"
            item_records.find { |item| item.name == "Hide" } || item_records.find { |item| item.armor? }
          when "Fighter"
            item_records.find { |item| item.name == "Chain Mail" } || item_records.find { |item| item.armor? }
          when "Rogue"
            item_records.find { |item| item.name == "Leather" } || item_records.find { |item| item.armor? }
          else
            item_records.find { |item| item.armor? }
          end

  CharacterItem.create!(character: char, item: weapon, equipped: true) if weapon
  CharacterItem.create!(character: char, item: armor, equipped: true) if armor

  # Give each character a backpack and some basic gear
  backpack = item_records.find { |item| item.name == "Backpack" }
  rations = item_records.find { |item| item.name == "Rations (1 day)" }
  waterskin = item_records.find { |item| item.name == "Waterskin" }

  CharacterItem.create!(character: char, item: backpack) if backpack
  CharacterItem.create!(character: char, item: rations) if rations
  CharacterItem.create!(character: char, item: waterskin) if waterskin
end

# === GENERATE BATTLE BOARD ===
board = BattleServices::BoardGenerator.new(name: "Training Grounds").run

# === TEST BATTLE ===
battle = Battle.create!(player_1: User.first, player_2: User.second, status: "pending", battle_board: board)

team1 = User.first.characters.limit(3)
team2 = User.second.characters.limit(3)

BattleServices::BattleInitializer.new(battle, team1, team2).run

# === ABILITIES ===
# PHB Class Features and Abilities with comprehensive data mapping

# === BARBARIAN ABILITIES ===
rage = Ability.create!(
  name: "Rage",
  description: "In battle, you fight with primal ferocity. On your turn, you can enter a rage as a bonus action.",
  ability_type: "class_feature",
  source: "Barbarian",
  level_required: 1,
  action_type: "bonus_action",
  duration: "1 minute",
  range: "Self",
  uses_per_rest: "long_rest",
  max_uses: 2,
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {
    "3" => { "max_uses" => 3 },
    "6" => { "max_uses" => 4 },
    "12" => { "max_uses" => 5 },
    "17" => { "max_uses" => 6 },
    "20" => { "max_uses" => 999 }
  },
  notes: "While raging: +2 damage to STR melee attacks, advantage on STR checks/saves, resistance to bludgeoning/piercing/slashing damage. Cannot cast spells or concentrate. Ends if you don't attack or take damage."
)

unarmored_defense_barbarian = Ability.create!(
  name: "Unarmored Defense",
  description: "While you are not wearing any armor, your Armor Class equals 10 + your Dexterity modifier + your Constitution modifier.",
  ability_type: "class_feature",
  source: "Barbarian",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You can use a shield and still gain this benefit."
)

reckless_attack = Ability.create!(
  name: "Reckless Attack",
  description: "You can throw aside all concern for defense to attack with fierce desperation.",
  ability_type: "class_feature",
  source: "Barbarian",
  level_required: 2,
  action_type: "action",
  duration: "Until start of next turn",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "When you make your first attack on your turn, you can decide to attack recklessly. You have advantage on melee weapon attack rolls using STR, but attack rolls against you have advantage until your next turn."
)

danger_sense = Ability.create!(
  name: "Danger Sense",
  description: "You gain an uncanny sense of when things nearby aren't as they should be.",
  ability_type: "class_feature",
  source: "Barbarian",
  level_required: 2,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You have advantage on Dexterity saving throws against effects that you can see, such as traps and spells. You can't be blinded, deafened, or incapacitated."
)

# === FIGHTER ABILITIES ===
second_wind = Ability.create!(
  name: "Second Wind",
  description: "You have a limited well of stamina that you can draw on to protect yourself from harm.",
  ability_type: "class_feature",
  source: "Fighter",
  level_required: 1,
  action_type: "bonus_action",
  duration: "Instantaneous",
  range: "Self",
  uses_per_rest: "short_rest",
  max_uses: 1,
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You regain 1d10 + your fighter level hit points."
)

action_surge = Ability.create!(
  name: "Action Surge",
  description: "You can push yourself beyond your normal limits for a moment.",
  ability_type: "class_feature",
  source: "Fighter",
  level_required: 2,
  action_type: "action",
  duration: "Current turn",
  range: "Self",
  uses_per_rest: "short_rest",
  max_uses: 1,
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {
    "17" => { "max_uses" => 2 }
  },
  notes: "On your turn, you can take one additional action on top of your regular action and a possible bonus action."
)

fighting_style_archery = Ability.create!(
  name: "Fighting Style: Archery",
  description: "You gain a +2 bonus to attack rolls you make with ranged weapons.",
  ability_type: "class_feature",
  source: "Fighter",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "This bonus applies to all ranged weapon attacks."
)

fighting_style_defense = Ability.create!(
  name: "Fighting Style: Defense",
  description: "While you are wearing armor, you gain a +1 bonus to AC.",
  ability_type: "class_feature",
  source: "Fighter",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "This bonus applies while wearing any armor."
)

fighting_style_dueling = Ability.create!(
  name: "Fighting Style: Dueling",
  description: "When you are wielding a melee weapon in one hand and no other weapons, you gain a +2 bonus to damage rolls with that weapon.",
  ability_type: "class_feature",
  source: "Fighter",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "The weapon must be one-handed and you cannot be holding another weapon or shield."
)

# === ROGUE ABILITIES ===
sneak_attack = Ability.create!(
  name: "Sneak Attack",
  description: "You know how to strike subtly and exploit a foe's distraction.",
  ability_type: "class_feature",
  source: "Rogue",
  level_required: 1,
  action_type: "passive",
  duration: "Instantaneous",
  range: "Weapon range",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  damage_dice: "1d6",
  scaling: {
    "3" => { "damage_dice" => "2d6" },
    "5" => { "damage_dice" => "3d6" },
    "7" => { "damage_dice" => "4d6" },
    "9" => { "damage_dice" => "5d6" },
    "11" => { "damage_dice" => "6d6" },
    "13" => { "damage_dice" => "7d6" },
    "15" => { "damage_dice" => "8d6" },
    "17" => { "damage_dice" => "9d6" },
    "19" => { "damage_dice" => "10d6" }
  },
  notes: "Once per turn, you can deal extra damage to one creature you hit with an attack if you have advantage on the attack roll or if another enemy is within 5 feet of the target. The attack must use a finesse or ranged weapon."
)

expertise = Ability.create!(
  name: "Expertise",
  description: "Choose two of your skill proficiencies. Your proficiency bonus is doubled for any ability check you make that uses either of the chosen proficiencies.",
  ability_type: "class_feature",
  source: "Rogue",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {
    "6" => { "additional_skills" => 2 }
  },
  notes: "At 1st level, choose two skills. At 6th level, choose two more skills."
)

thieves_cant = Ability.create!(
  name: "Thieves' Cant",
  description: "You learned thieves' cant, a secret mix of dialect, jargon, and code that allows you to hide messages in seemingly normal conversation.",
  ability_type: "class_feature",
  source: "Rogue",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You can communicate with other rogues who know thieves' cant, and you can hide messages in normal conversation."
)

cunning_action = Ability.create!(
  name: "Cunning Action",
  description: "Your quick thinking and agility allow you to move and act quickly.",
  ability_type: "class_feature",
  source: "Rogue",
  level_required: 2,
  action_type: "bonus_action",
  duration: "Instantaneous",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You can take a bonus action on each of your turns to take the Dash, Disengage, or Hide action."
)

uncanny_dodge = Ability.create!(
  name: "Uncanny Dodge",
  description: "When an attacker that you can see hits you with an attack, you can use your reaction to halve the attack's damage against you.",
  ability_type: "class_feature",
  source: "Rogue",
  level_required: 5,
  action_type: "reaction",
  duration: "Instantaneous",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You must be able to see the attacker and not be incapacitated."
)

# === WIZARD ABILITIES ===
arcane_recovery = Ability.create!(
  name: "Arcane Recovery",
  description: "You have learned to regain some of your magical energy by studying your spellbook.",
  ability_type: "class_feature",
  source: "Wizard",
  level_required: 1,
  action_type: "action",
  duration: "Instantaneous",
  range: "Self",
  uses_per_rest: "long_rest",
  max_uses: 1,
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "During a short rest, you can recover spent spell slots with a combined level equal to or less than half your wizard level (minimum 1), and none of the slots can be 6th level or higher."
)

# === CLERIC ABILITIES ===
channel_divinity = Ability.create!(
  name: "Channel Divinity",
  description: "You gain the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.",
  ability_type: "class_feature",
  source: "Cleric",
  level_required: 2,
  action_type: "action",
  duration: "Varies",
  range: "Varies",
  uses_per_rest: "short_rest",
  max_uses: 1,
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {
    "6" => { "max_uses" => 2 },
    "18" => { "max_uses" => 3 }
  },
  notes: "The effect depends on your Divine Domain. Some Channel Divinity effects require saving throws."
)

turn_undead = Ability.create!(
  name: "Turn Undead",
  description: "You present your holy symbol and speak a prayer censuring the undead.",
  ability_type: "class_feature",
  source: "Cleric",
  level_required: 2,
  action_type: "action",
  duration: "1 minute",
  range: "30 feet",
  area_of_effect: "30-foot radius",
  uses_per_rest: "short_rest",
  max_uses: 1,
  cooldown_turns: 0,
  prerequisites: {},
  components: { "verbal" => true, "somatic" => true, "material" => "holy symbol" },
  saving_throw: "Wisdom",
  scaling: {
    "5" => { "destroy_cr" => 0.5 },
    "8" => { "destroy_cr" => 1 },
    "11" => { "destroy_cr" => 2 },
    "14" => { "destroy_cr" => 3 },
    "17" => { "destroy_cr" => 4 }
  },
  notes: "Each undead within 30 feet must make a Wisdom saving throw. Failed saves cause the creature to be turned for 1 minute. At higher levels, destroys undead of certain CR instead of turning them."
)

# === RACIAL ABILITIES ===
darkvision = Ability.create!(
  name: "Darkvision",
  description: "You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.",
  ability_type: "racial_trait",
  source: "Elf",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "60 feet",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "You can't discern color in darkness, only shades of gray."
)

fey_ancestry = Ability.create!(
  name: "Fey Ancestry",
  description: "You have advantage on saving throws against being charmed, and magic can't put you to sleep.",
  ability_type: "racial_trait",
  source: "Elf",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "This includes both magical and non-magical charm effects."
)

halfling_luck = Ability.create!(
  name: "Lucky",
  description: "When you roll a 1 on the d20 for an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll.",
  ability_type: "racial_trait",
  source: "Halfling",
  level_required: 1,
  action_type: "passive",
  duration: "Permanent",
  range: "Self",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: {},
  scaling: {},
  notes: "This ability only triggers on natural 1s, not when your total roll equals 1."
)

# === CANTRIPS ===
fire_bolt = Ability.create!(
  name: "Fire Bolt",
  description: "You hurl a mote of fire at a creature or object within range.",
  ability_type: "cantrip",
  source: "Wizard",
  level_required: 1,
  action_type: "action",
  duration: "Instantaneous",
  range: "120 feet",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: { "verbal" => true, "somatic" => true },
  damage_dice: "1d10",
  damage_type: "fire",
  scaling: {
    "5" => { "damage_dice" => "2d10" },
    "11" => { "damage_dice" => "3d10" },
    "17" => { "damage_dice" => "4d10" }
  },
  notes: "Make a ranged spell attack. On hit, the target takes fire damage. A flammable object hit by this spell ignites if it isn't being worn or carried."
)

mage_hand = Ability.create!(
  name: "Mage Hand",
  description: "A spectral, floating hand appears at a point you choose within range.",
  ability_type: "cantrip",
  source: "Wizard",
  level_required: 1,
  action_type: "action",
  duration: "1 minute",
  range: "30 feet",
  uses_per_rest: "unlimited",
  cooldown_turns: 0,
  prerequisites: {},
  components: { "verbal" => true, "somatic" => true },
  scaling: {},
  notes: "The hand can manipulate objects, open doors, stow or retrieve items, but can't attack, activate magic items, or carry more than 10 pounds."
)

# Assign abilities to characters based on their class and race
Character.all.each do |char|
  case char.character_class.name
  when "Barbarian"
    CharacterAbility.create!(character: char, ability: rage, uses_remaining: 2)
    CharacterAbility.create!(character: char, ability: unarmored_defense_barbarian, uses_remaining: nil)
    if char.level >= 2
      CharacterAbility.create!(character: char, ability: reckless_attack, uses_remaining: nil)
      CharacterAbility.create!(character: char, ability: danger_sense, uses_remaining: nil)
    end
  when "Fighter"
    CharacterAbility.create!(character: char, ability: second_wind, uses_remaining: 1)
    CharacterAbility.create!(character: char, ability: fighting_style_defense, uses_remaining: nil)
    if char.level >= 2
      CharacterAbility.create!(character: char, ability: action_surge, uses_remaining: 1)
    end
  when "Rogue"
    CharacterAbility.create!(character: char, ability: sneak_attack, uses_remaining: nil)
    CharacterAbility.create!(character: char, ability: expertise, uses_remaining: nil)
    CharacterAbility.create!(character: char, ability: thieves_cant, uses_remaining: nil)
    if char.level >= 2
      CharacterAbility.create!(character: char, ability: cunning_action, uses_remaining: nil)
    end
  when "Wizard"
    CharacterAbility.create!(character: char, ability: arcane_recovery, uses_remaining: 1)
    CharacterAbility.create!(character: char, ability: fire_bolt, uses_remaining: nil)
    CharacterAbility.create!(character: char, ability: mage_hand, uses_remaining: nil)
  when "Cleric"
    if char.level >= 2
      CharacterAbility.create!(character: char, ability: channel_divinity, uses_remaining: 1)
      CharacterAbility.create!(character: char, ability: turn_undead, uses_remaining: 1)
    end
  end

  # Assign racial abilities
  case char.race.name
  when "Elf"
    CharacterAbility.create!(character: char, ability: darkvision, uses_remaining: nil)
    CharacterAbility.create!(character: char, ability: fey_ancestry, uses_remaining: nil)
  when "Halfling"
    CharacterAbility.create!(character: char, ability: halfling_luck, uses_remaining: nil)
  end
end

puts "Database seeded successfully!"
puts "Created #{Item.count} items (weapons, armor, and gear)"
puts "Created #{Character.count} characters across #{User.count} users"
puts "Created #{Battle.count} battle(s) ready for testing"
