require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:race) }
    it { should belong_to(:subrace) }
    it { should belong_to(:character_class) }
    it { should belong_to(:subclass) }
    it { should have_many(:ability_scores).dependent(:destroy) }
    it { should have_many(:character_items).dependent(:destroy) }
    it { should have_many(:items).through(:character_items) }
    it { should have_many(:character_abilities).dependent(:destroy) }
    it { should have_many(:abilities).through(:character_abilities) }
    it { should have_many(:battle_participants).dependent(:destroy) }
    it { should have_many(:character_class_levels).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_numericality_of(:level).only_integer.is_greater_than(0).is_less_than_or_equal_to(20) }
    it { should validate_numericality_of(:movement_speed).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:max_hp).only_integer.is_greater_than(0) }
  end

  describe 'ability score methods' do
    let(:character) { create(:character) }

    before do
      create(:ability_score, character: character, score_type: "STR", modified_score: 16)
      create(:ability_score, character: character, score_type: "DEX", modified_score: 14)
      create(:ability_score, character: character, score_type: "CON", modified_score: 12)
    end

    it 'returns correct ability scores' do
      expect(character.strength).to eq(16)
      expect(character.dexterity).to eq(14)
      expect(character.constitution).to eq(12)
    end

    it 'returns correct ability modifiers' do
      expect(character.strength_modifier).to eq(3)  # (16-10)/2
      expect(character.dexterity_modifier).to eq(2) # (14-10)/2
      expect(character.constitution_modifier).to eq(1) # (12-10)/2
    end
  end
end
