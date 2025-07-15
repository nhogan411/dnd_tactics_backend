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

ActiveRecord::Schema[8.0].define(version: 2025_07_14_011721) do
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
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["subclass_id"], name: "index_characters_on_subclass_id"
    t.index ["subrace_id"], name: "index_characters_on_subrace_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "item_type"
    t.jsonb "bonuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_visibility_range"
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
    t.index ["character_class_id"], name: "index_subclasses_on_character_class_id"
  end

  create_table "subraces", force: :cascade do |t|
    t.string "name"
    t.bigint "race_id", null: false
    t.jsonb "ability_modifiers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_subraces_on_race_id"
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
  add_foreign_key "character_items", "characters"
  add_foreign_key "character_items", "items"
  add_foreign_key "characters", "character_classes"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "subclasses"
  add_foreign_key "characters", "subraces"
  add_foreign_key "characters", "users"
  add_foreign_key "starting_squares", "battle_boards"
  add_foreign_key "subclasses", "character_classes"
  add_foreign_key "subraces", "races"
end
