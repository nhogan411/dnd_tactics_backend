# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_15_000010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "class_name"
    t.integer "level_required"
    t.string "action_type"
    t.integer "cooldown_turns"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ability_type"
    t.string "source"
    t.jsonb "prerequisites", default: {}
    t.jsonb "components", default: {}
    t.string "duration"
    t.string "range"
    t.string "area_of_effect"
    t.string "damage_dice"
    t.string "damage_type"
    t.string "saving_throw"
    t.string "uses_per_rest"
    t.integer "max_uses"
    t.string "recharge"
    t.jsonb "scaling", default: {}
    t.text "notes"
    t.index ["ability_type"], name: "index_abilities_on_ability_type"
    t.index ["action_type"], name: "index_abilities_on_action_type"
    t.index ["level_required"], name: "index_abilities_on_level_required"
    t.index ["source"], name: "index_abilities_on_source"
  end

  create_table "ability_scores", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.string "score_type"
    t.integer "base_score"
    t.integer "modified_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_ability_scores_on_character_id"
  end

  create_table "backgrounds", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.jsonb "skill_proficiencies", default: []
    t.jsonb "language_proficiencies", default: []
    t.jsonb "tool_proficiencies", default: []
    t.jsonb "equipment", default: {}
    t.integer "starting_gold", default: 0
    t.text "feature_name"
    t.text "feature_description"
    t.jsonb "suggested_characteristics", default: {}
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_proficiencies"], name: "index_backgrounds_on_language_proficiencies", using: :gin
    t.index ["name"], name: "index_backgrounds_on_name", unique: true
    t.index ["skill_proficiencies"], name: "index_backgrounds_on_skill_proficiencies", using: :gin
    t.index ["tool_proficiencies"], name: "index_backgrounds_on_tool_proficiencies", using: :gin
  end

  create_table "battle_boards", force: :cascade do |t|
    t.string "name"
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "battle_logs", force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "actor_id"
    t.bigint "target_id"
    t.string "action_type"
    t.jsonb "result_data"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_battle_logs_on_actor_id"
    t.index ["battle_id"], name: "index_battle_logs_on_battle_id"
    t.index ["target_id"], name: "index_battle_logs_on_target_id"
  end

  create_table "battle_participant_selections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "battle_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_battle_participant_selections_on_battle_id"
    t.index ["character_id"], name: "index_battle_participant_selections_on_character_id"
    t.index ["user_id"], name: "index_battle_participant_selections_on_user_id"
  end

  create_table "battle_participants", force: :cascade do |t|
    t.bigint "battle_id", null: false
    t.bigint "character_id", null: false
    t.bigint "user_id", null: false
    t.integer "team"
    t.integer "current_hp"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "initiative_roll"
    t.integer "turn_order"
    t.integer "pos_x"
    t.integer "pos_y"
    t.json "battle_ability_modifiers"
    t.json "status_effects"
    t.json "cooldowns"
    t.index ["battle_id"], name: "index_battle_participants_on_battle_id"
    t.index ["character_id"], name: "index_battle_participants_on_character_id"
    t.index ["user_id"], name: "index_battle_participants_on_user_id"
  end

  create_table "battles", force: :cascade do |t|
    t.bigint "user_1_id", null: false
    t.bigint "user_2_id", null: false
    t.bigint "winner_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "battle_board_id", null: false
    t.integer "current_turn_index"
    t.index ["battle_board_id"], name: "index_battles_on_battle_board_id"
    t.index ["user_1_id"], name: "index_battles_on_user_1_id"
    t.index ["user_2_id"], name: "index_battles_on_user_2_id"
    t.index ["winner_id"], name: "index_battles_on_winner_id"
  end

  create_table "board_squares", force: :cascade do |t|
    t.bigint "battle_board_id", null: false
    t.integer "x"
    t.integer "y"
    t.integer "height"
    t.integer "brightness"
    t.string "surface_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_board_id"], name: "index_board_squares_on_battle_board_id"
  end

  create_table "character_abilities", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "ability_id", null: false
    t.integer "uses_remaining"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_character_abilities_on_ability_id"
    t.index ["character_id"], name: "index_character_abilities_on_character_id"
  end

  create_table "character_class_levels", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "character_class_id", null: false
    t.integer "level", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_class_id"], name: "index_character_class_levels_on_character_class_id"
    t.index ["character_id"], name: "index_character_class_levels_on_character_id"
  end

  create_table "character_classes", force: :cascade do |t|
    t.string "name"
    t.jsonb "ability_requirements"
    t.jsonb "bonuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "hit_die", default: 8
    t.jsonb "primary_ability", default: []
    t.jsonb "saving_throw_proficiencies", default: []
    t.jsonb "skill_proficiencies", default: {}
    t.jsonb "weapon_proficiencies", default: []
    t.jsonb "armor_proficiencies", default: []
    t.jsonb "tool_proficiencies", default: []
    t.jsonb "starting_equipment", default: {}
    t.jsonb "spellcasting", default: {}
    t.jsonb "class_features", default: {}
    t.jsonb "multiclass_requirements", default: {}
    t.text "notes"
    t.index ["hit_die"], name: "index_character_classes_on_hit_die"
    t.index ["primary_ability"], name: "index_character_classes_on_primary_ability", using: :gin
  end

  create_table "character_feats", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "feat_id", null: false
    t.integer "level_gained", default: 1
    t.jsonb "selected_options", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "feat_id"], name: "index_character_feats_on_character_id_and_feat_id", unique: true
    t.index ["character_id"], name: "index_character_feats_on_character_id"
    t.index ["feat_id"], name: "index_character_feats_on_feat_id"
    t.index ["level_gained"], name: "index_character_feats_on_level_gained"
  end

  create_table "character_items", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "equipped"
    t.index ["character_id"], name: "index_character_items_on_character_id"
    t.index ["item_id"], name: "index_character_items_on_item_id"
  end

  create_table "character_spells", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "spell_id", null: false
    t.boolean "prepared", default: false
    t.boolean "known", default: true
    t.string "source", default: "class", null: false
    t.integer "level_gained", default: 1, null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "spell_id"], name: "index_character_spells_on_character_id_and_spell_id", unique: true
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["known"], name: "index_character_spells_on_known"
    t.index ["prepared"], name: "index_character_spells_on_prepared"
    t.index ["source"], name: "index_character_spells_on_source"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.bigint "race_id", null: false
    t.bigint "subrace_id", null: false
    t.bigint "character_class_id", null: false
    t.bigint "subclass_id", null: false
    t.integer "max_hp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.integer "movement_speed"
    t.integer "visibility_range"
    t.integer "current_hp", default: 0
    t.integer "temporary_hp", default: 0
    t.integer "armor_class", default: 10
    t.integer "initiative_modifier", default: 0
    t.integer "proficiency_bonus", default: 2
    t.boolean "inspiration", default: false
    t.integer "experience_points", default: 0
    t.integer "next_level_xp", default: 300
    t.integer "carrying_capacity", default: 150
    t.integer "currency_gp", default: 0
    t.integer "currency_sp", default: 0
    t.integer "currency_cp", default: 0
    t.jsonb "skill_proficiencies", default: []
    t.jsonb "skill_expertise", default: []
    t.jsonb "weapon_proficiencies", default: []
    t.jsonb "armor_proficiencies", default: []
    t.jsonb "tool_proficiencies", default: []
    t.jsonb "language_proficiencies", default: []
    t.string "spellcasting_ability"
    t.integer "spell_save_dc", default: 8
    t.integer "spell_attack_bonus", default: 0
    t.jsonb "spell_slots", default: {}
    t.jsonb "spells_known", default: []
    t.jsonb "cantrips_known", default: []
    t.jsonb "conditions", default: {}
    t.jsonb "temporary_effects", default: {}
    t.bigint "background_id"
    t.text "personality_traits"
    t.text "ideals"
    t.text "bonds"
    t.text "flaws"
    t.jsonb "spell_slots_used", default: {}
    t.jsonb "attuned_items", default: []
    t.integer "attunement_slots", default: 3
    t.integer "death_save_successes", default: 0
    t.integer "death_save_failures", default: 0
    t.jsonb "hit_dice_used", default: {}
    t.index ["attuned_items"], name: "index_characters_on_attuned_items", using: :gin
    t.index ["background_id"], name: "index_characters_on_background_id"
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["conditions"], name: "index_characters_on_conditions", using: :gin
    t.index ["experience_points"], name: "index_characters_on_experience_points"
    t.index ["hit_dice_used"], name: "index_characters_on_hit_dice_used", using: :gin
    t.index ["level"], name: "index_characters_on_level"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["skill_proficiencies"], name: "index_characters_on_skill_proficiencies", using: :gin
    t.index ["spell_slots_used"], name: "index_characters_on_spell_slots_used", using: :gin
    t.index ["subclass_id"], name: "index_characters_on_subclass_id"
    t.index ["subrace_id"], name: "index_characters_on_subrace_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "feats", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.jsonb "prerequisites", default: {}
    t.jsonb "benefits", default: {}
    t.jsonb "ability_score_increases", default: {}
    t.boolean "half_feat", default: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["half_feat"], name: "index_feats_on_half_feat"
    t.index ["name"], name: "index_feats_on_name", unique: true
    t.index ["prerequisites"], name: "index_feats_on_prerequisites", using: :gin
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "item_type"
    t.jsonb "bonuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.text "notes"
    t.string "rarity", default: "common"
    t.integer "cost_gp"
    t.decimal "weight_lbs", precision: 8, scale: 2
    t.boolean "requires_attunement", default: false
    t.string "damage_dice"
    t.string "damage_type"
    t.string "weapon_type"
    t.string "weapon_category"
    t.integer "range_normal"
    t.integer "range_long"
    t.jsonb "weapon_properties", default: {}
    t.integer "armor_class"
    t.string "armor_type"
    t.integer "max_dex_bonus"
    t.integer "strength_requirement"
    t.boolean "stealth_disadvantage", default: false
    t.boolean "is_magical", default: false
    t.integer "magic_bonus"
    t.integer "spell_attack_bonus"
    t.integer "spell_save_dc_bonus"
    t.integer "max_charges"
    t.integer "charges_per_day"
    t.boolean "consumable", default: false
    t.index ["armor_type"], name: "index_items_on_armor_type"
    t.index ["is_magical"], name: "index_items_on_is_magical"
    t.index ["item_type"], name: "index_items_on_item_type"
    t.index ["rarity"], name: "index_items_on_rarity"
    t.index ["weapon_type"], name: "index_items_on_weapon_type"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_visibility_range"
    t.text "description"
    t.string "size", default: "Medium"
    t.integer "speed", default: 30
    t.jsonb "languages", default: []
    t.jsonb "proficiencies", default: {}
    t.jsonb "traits", default: {}
    t.text "notes"
    t.index ["size"], name: "index_races_on_size"
  end

  create_table "spells", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "level", default: 0, null: false
    t.string "school", null: false
    t.string "casting_time", null: false
    t.string "range", null: false
    t.string "duration", null: false
    t.jsonb "components", default: {}
    t.string "material_components"
    t.boolean "concentration", default: false
    t.boolean "ritual", default: false
    t.text "at_higher_levels"
    t.jsonb "class_lists", default: []
    t.jsonb "damage", default: {}
    t.jsonb "effects", default: {}
    t.string "saving_throw"
    t.string "attack_type"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_lists"], name: "index_spells_on_class_lists", using: :gin
    t.index ["concentration"], name: "index_spells_on_concentration"
    t.index ["level"], name: "index_spells_on_level"
    t.index ["name"], name: "index_spells_on_name", unique: true
    t.index ["ritual"], name: "index_spells_on_ritual"
    t.index ["school"], name: "index_spells_on_school"
  end

  create_table "starting_squares", force: :cascade do |t|
    t.bigint "battle_board_id", null: false
    t.integer "x"
    t.integer "y"
    t.integer "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_board_id"], name: "index_starting_squares_on_battle_board_id"
  end

  create_table "subclasses", force: :cascade do |t|
    t.string "name"
    t.bigint "character_class_id", null: false
    t.jsonb "bonuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "subclass_features", default: {}
    t.jsonb "spells", default: []
    t.jsonb "proficiencies", default: {}
    t.text "notes"
    t.index ["character_class_id"], name: "index_subclasses_on_character_class_id"
    t.index ["spells"], name: "index_subclasses_on_spells", using: :gin
  end

  create_table "subraces", force: :cascade do |t|
    t.string "name"
    t.bigint "race_id", null: false
    t.jsonb "ability_modifiers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "size"
    t.integer "speed"
    t.jsonb "languages", default: []
    t.jsonb "proficiencies", default: {}
    t.jsonb "traits", default: {}
    t.jsonb "spells", default: []
    t.text "notes"
    t.index ["race_id"], name: "index_subraces_on_race_id"
    t.index ["size"], name: "index_subraces_on_size"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ability_scores", "characters"
  add_foreign_key "battle_logs", "battles"
  add_foreign_key "battle_logs", "characters", column: "actor_id"
  add_foreign_key "battle_logs", "characters", column: "target_id"
  add_foreign_key "battle_participant_selections", "battles"
  add_foreign_key "battle_participant_selections", "characters"
  add_foreign_key "battle_participant_selections", "users"
  add_foreign_key "battle_participants", "battles"
  add_foreign_key "battle_participants", "characters"
  add_foreign_key "battle_participants", "users"
  add_foreign_key "battles", "battle_boards"
  add_foreign_key "battles", "users", column: "user_1_id"
  add_foreign_key "battles", "users", column: "user_2_id"
  add_foreign_key "battles", "users", column: "winner_id"
  add_foreign_key "board_squares", "battle_boards"
  add_foreign_key "character_abilities", "abilities"
  add_foreign_key "character_abilities", "characters"
  add_foreign_key "character_class_levels", "character_classes"
  add_foreign_key "character_class_levels", "characters"
  add_foreign_key "character_feats", "characters"
  add_foreign_key "character_feats", "feats"
  add_foreign_key "character_items", "characters"
  add_foreign_key "character_items", "items"
  add_foreign_key "character_spells", "characters"
  add_foreign_key "character_spells", "spells"
  add_foreign_key "characters", "backgrounds"
  add_foreign_key "characters", "character_classes"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "subclasses"
  add_foreign_key "characters", "subraces"
  add_foreign_key "characters", "users"
  add_foreign_key "starting_squares", "battle_boards"
  add_foreign_key "subclasses", "character_classes"
  add_foreign_key "subraces", "races"
end
